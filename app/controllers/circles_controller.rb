module Api
  module V1
    class CirclesController < ApplicationController
      def create
        # TODO: Delegate to CircleCreationService
        render json: { message: "Circle created (stub)" }, status: :created
      end

      def update
        # TODO: Delegate to CircleUpdateService
        render json: { message: "Circle updated (stub)" }, status: :ok
      end

      def index
        # TODO: Delegate to CircleQueryService
        render json: { message: "Circles listed (stub)" }, status: :ok
      end

      def destroy
        # TODO: Delegate to CircleDeletionService
        render json: { message: "Circle deleted (stub)" }, status: :no_content
      end
    end
  end
end