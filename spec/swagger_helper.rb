# frozen_string_literal: true

require 'rails_helper'
require 'rswag/specs'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s
  
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Frames and Circles API',
        version: 'v1',
        description: 'API RESTful para cadastro e gerenciamento de quadros e círculos associados'
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3000',
          description: 'Development server'
        }
      ],
      components: {
        schemas: {
          Frame: {
            type: 'object',
            properties: {
              id: { type: 'integer' },
              center_x: { type: 'number', format: 'float' },
              center_y: { type: 'number', format: 'float' },
              width: { type: 'number', format: 'float' },
              height: { type: 'number', format: 'float' },
              created_at: { type: 'string', format: 'date-time' },
              updated_at: { type: 'string', format: 'date-time' }
            },
            required: ['center_x', 'center_y', 'width', 'height']
          },
          Circle: {
            type: 'object',
            properties: {
              id: { type: 'integer' },
              center_x: { type: 'number', format: 'float' },
              center_y: { type: 'number', format: 'float' },
              diameter: { type: 'number', format: 'float' },
              frame_id: { type: 'integer' },
              created_at: { type: 'string', format: 'date-time' },
              updated_at: { type: 'string', format: 'date-time' }
            },
            required: ['center_x', 'center_y', 'diameter', 'frame_id']
          },
          Error: {
            type: 'object',
            properties: {
              error: { type: 'string' },
              details: { 
                type: 'array',
                items: { type: 'string' }
              }
            }
          }
        }
      }
    }
  }
  
  config.swagger_format = :yaml
end
