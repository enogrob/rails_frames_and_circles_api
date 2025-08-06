module Api
  module V1
    class FramesController < ApplicationController
      def index
        frames = Frame.all
        render json: frames, status: :ok
      end

      def create
        frame = FrameCreationService.call(frame_params)
        if frame.is_a?(Frame) && frame.persisted?
          render json: frame, status: :created
        else
          render json: { errors: frame.errors.map(&:full_message) }, status: :unprocessable_entity
        end
      end

      def show
        frame = Frame.find_by(id: params[:id])
        if frame
          render json: frame, status: :ok
        else
          render json: { errors: [ "Frame not found" ] }, status: :not_found
        end
      end

      def update
        frame = Frame.find_by(id: params[:id])
        if frame.nil?
          render json: { errors: [ "Frame not found" ] }, status: :not_found
        elsif frame.update(frame_params)
          render json: frame, status: :ok
        else
          render json: { errors: frame.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        frame = Frame.find_by(id: params[:id])
        if frame.nil?
          render json: { errors: [ "Frame not found" ] }, status: :not_found
        elsif frame.circles.exists?
          render json: { errors: [ "Cannot delete frame with circles" ] }, status: :unprocessable_entity
        else
          frame.destroy
          head :no_content
        end
      end

      private

      def frame_params
        params.require(:frame).permit(:center_x, :center_y, :width, :height)
      end
    end
  end
end
