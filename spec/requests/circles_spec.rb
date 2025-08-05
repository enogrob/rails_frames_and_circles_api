require 'swagger_helper'

RSpec.describe 'circles', type: :request do
  path '/api/v1/frames/{frame_id}/circles' do
    parameter name: 'frame_id', in: :path, type: :integer, description: 'Frame ID'

    get('list circles') do
      tags 'Circles'
      description 'Lista todos os círculos de um quadro'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/Circle' }
        
        run_test!
      end

      response(404, 'frame not found') do
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end

    post('create circle') do
      tags 'Circles'
      description 'Cria um novo círculo no quadro'
      consumes 'application/json'
      produces 'application/json'
      
      parameter name: :circle, in: :body, schema: {
        type: :object,
        properties: {
          center_x: { type: :number, format: :float },
          center_y: { type: :number, format: :float },
          diameter: { type: :number, format: :float }
        },
        required: ['center_x', 'center_y', 'diameter']
      }

      response(201, 'created') do
        schema '$ref' => '#/components/schemas/Circle'
        run_test!
      end

      response(422, 'unprocessable entity') do
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end
  end

  path '/api/v1/circles/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Circle ID'

    get('show circle') do
      tags 'Circles'
      description 'Exibe um círculo específico'
      produces 'application/json'

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/Circle'
        run_test!
      end

      response(404, 'not found') do
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end

    put('update circle') do
      tags 'Circles'
      description 'Atualiza um círculo'
      consumes 'application/json'
      produces 'application/json'
      
      parameter name: :circle, in: :body, schema: {
        type: :object,
        properties: {
          center_x: { type: :number, format: :float },
          center_y: { type: :number, format: :float },
          diameter: { type: :number, format: :float }
        }
      }

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/Circle'
        run_test!
      end

      response(404, 'not found') do
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end

      response(422, 'unprocessable entity') do
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end

    delete('delete circle') do
      tags 'Circles'
      description 'Remove um círculo'

      response(204, 'no content') do
        run_test!
      end

      response(404, 'not found') do
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end
  end
end