module Api
  module V1
    class FramesController < ApplicationController
      def create
        # TODO: Delegate to FrameCreationService
        render json: { message: "Frame created (stub)" }, status: :created
      end

      def show
        # TODO: Show frame details and circle metrics
        render json: { message: "Frame details (stub)" }, status: :ok
      end

      def destroy
        # TODO: Delegate to FrameDeletionService
        render json: { message: "Frame deleted (stub)" }, status: :no_content
      end
    end
  end
end