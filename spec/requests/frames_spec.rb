require 'swagger_helper'

RSpec.describe 'frames', type: :request do
  path '/api/v1/frames' do
    get('list frames') do
      tags 'Frames'
      description 'Lista todos os quadros'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/Frame' }

        run_test!
      end
    end

    post('create frame') do
      tags 'Frames'
      description 'Cria um novo quadro'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :frame, in: :body, schema: {
        type: :object,
        properties: {
          center_x: { type: :number, format: :float },
          center_y: { type: :number, format: :float },
          width: { type: :number, format: :float },
          height: { type: :number, format: :float }
        },
        required: [ 'center_x', 'center_y', 'width', 'height' ]
      }

      response(201, 'created') do
        schema '$ref' => '#/components/schemas/Frame'

        let(:frame) do
          {
            frame: {
              center_x: 10.0,
              center_y: 15.0,
              width: 20.0,
              height: 30.0
            }
          }
        end

        run_test!
      end

      response(422, 'unprocessable entity') do
        schema '$ref' => '#/components/schemas/Error'

        let(:frame) do
          {
            frame: {
              center_x: nil,
              center_y: 15.0,
              width: 20.0,
              height: 30.0
            }
          }
        end

        run_test!
      end
    end
  end

  path '/api/v1/frames/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Frame ID'

    get('show frame') do
      tags 'Frames'
      description 'Exibe um quadro específico com estatísticas'
      produces 'application/json'

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/Frame'
        let!(:frame) { Frame.create!(center_x: 0, center_y: 0, width: 10, height: 10) }
        let(:id) { frame.id }
        run_test!
      end

      response(404, 'not found') do
        schema '$ref' => '#/components/schemas/Error'

        let(:id) { 99999 }

        run_test!
      end
    end

    put('update frame') do
      tags 'Frames'
      description 'Atualiza um quadro'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :frame, in: :body, schema: {
        type: :object,
        properties: {
          center_x: { type: :number, format: :float },
          center_y: { type: :number, format: :float },
          width: { type: :number, format: :float },
          height: { type: :number, format: :float }
        }
      }

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/Frame'
        let!(:frame_record) { Frame.create!(center_x: 0, center_y: 0, width: 10, height: 10) }
        let(:id) { frame_record.id }
        let(:frame) do
          {
            frame: {
              center_x: 12.0,
              center_y: 18.0,
              width: 25.0,
              height: 35.0
            }
          }
        end
        run_test!
      end

      response(404, 'not found') do
        schema '$ref' => '#/components/schemas/Error'

        let(:id) { 99999 }
        let(:frame) do
          {
            frame: {
              center_x: 12.0,
              center_y: 18.0,
              width: 25.0,
              height: 35.0
            }
          }
        end

        run_test!
      end

      response(422, 'unprocessable entity') do
        schema '$ref' => '#/components/schemas/Error'
        let!(:frame_record) { Frame.create!(center_x: 0, center_y: 0, width: 10, height: 10) }
        let(:id) { frame_record.id }
        let(:frame) do
          {
            frame: {
              center_x: nil,
              center_y: 18.0,
              width: 25.0,
              height: 35.0
            }
          }
        end
        run_test!
      end
    end

    delete('delete frame') do
      tags 'Frames'
      description 'Remove um quadro'

      response(204, 'no content') do
        let!(:frame) { Frame.create!(center_x: 0, center_y: 0, width: 10, height: 10) }
        let(:id) { frame.id }
        run_test!
      end

      response(404, 'not found') do
        schema '$ref' => '#/components/schemas/Error'

        let(:id) { 99999 }

        run_test!
      end
    end
  end
end
