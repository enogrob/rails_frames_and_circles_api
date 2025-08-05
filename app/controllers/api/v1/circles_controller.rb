module Api
  module V1
    class CirclesController < ApplicationController
      before_action :set_frame, only: [:create]
      before_action :set_circle, only: [:show, :update, :destroy]

      def index
        frame = Frame.find_by(id: params[:frame_id])
        unless frame
          render json: { errors: ["Frame not found"] }, status: :not_found and return
        end
        circles = frame.circles
        render json: circles, status: :ok
      end

      def show
        if @circle
          render json: @circle, status: :ok
        else
          render json: { errors: ["Circle not found"] }, status: :not_found
        end
      end

      def create
        result = CircleCreationService.call(@frame, circle_params)
        if result.is_a?(Circle) && result.persisted?
          render json: result, status: :created
        else
          render json: { errors: result.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @circle.nil?
          render json: { errors: ["Circle not found"] }, status: :not_found
        else
          if @circle.update(circle_params)
            render json: @circle, status: :ok
          else
            render json: { errors: @circle.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end

      def destroy
        if @circle.nil?
          render json: { errors: ["Circle not found"] }, status: :not_found
        else
          CircleDeletionService.call(@circle)
          head :no_content
        end
      end

      private

      def set_frame
        @frame = Frame.find_by(id: params[:frame_id])
        render json: { errors: ["Frame not found"] }, status: :not_found unless @frame
      end

      def set_circle
        @circle = Circle.find_by(id: params[:id])
      end

      def circle_params
        params.require(:circle).permit(:center_x, :center_y, :diameter)
      end
    end
  end
end