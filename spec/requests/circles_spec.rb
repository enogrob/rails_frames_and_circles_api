require 'swagger_helper'

RSpec.describe 'circles', type: :request do
  path '/api/v1/frames/{frame_id}/circles' do
    parameter name: 'frame_id', in: :path, type: :integer, description: 'Frame ID'

    get('list circles') do
      tags 'Circles'
      description 'Lista todos os círculos de um quadro'
      produces 'application/json'

      response(200, 'successful') do
      let!(:frame) { Frame.create!(center_x: 0, center_y: 0, width: 100, height: 100) }
        let!(:circle) { Circle.create!(frame: frame, center_x: 5.0, center_y: 8.0, diameter: 4.0) }
        let(:frame_id) { frame.id }

        schema type: :array, items: { '$ref' => '#/components/schemas/Circle' }
        run_test!
      end

      response(404, 'frame not found') do
        schema '$ref' => '#/components/schemas/Error'
        let(:frame_id) { 99999 }
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
        required: [ 'center_x', 'center_y', 'diameter' ]
      }

      response(201, 'created') do
      let!(:frame) { Frame.create!(center_x: 0, center_y: 0, width: 100, height: 100) }
        let(:frame_id) { frame.id }
        let(:circle) { { center_x: 5.0, center_y: 8.0, diameter: 4.0 } }
        let(:raw_post) { circle.to_json }
        schema '$ref' => '#/components/schemas/Circle'
        run_test!
      end

      response(422, 'unprocessable entity') do
      let!(:frame) { Frame.create!(center_x: 0, center_y: 0, width: 100, height: 100) }
        let(:frame_id) { frame.id }
        let(:circle) { { center_x: nil, center_y: 8.0, diameter: 4.0 } }
        let(:raw_post) { circle.to_json }
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
      let!(:frame) { Frame.create!(center_x: 0, center_y: 0, width: 100, height: 100) }
        let!(:circle) { Circle.create!(frame: frame, center_x: 5.0, center_y: 8.0, diameter: 4.0) }
        let(:id) { circle.id }
        schema '$ref' => '#/components/schemas/Circle'
        run_test!
      end

      response(404, 'not found') do
        schema '$ref' => '#/components/schemas/Error'
        let(:id) { 99999 }
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
          circle: {
            type: :object,
            properties: {
              center_x: { type: :number, format: :float, nullable: true },
              center_y: { type: :number, format: :float },
              diameter: { type: :number, format: :float }
            },
            required: [ "center_y", "diameter" ]
          }
        },
        required: [ "circle" ]
      }

      response(200, 'successful') do
        let!(:frame) { Frame.create!(center_x: 0, center_y: 0, width: 100, height: 100) }
        let!(:circle) { Circle.create!(frame: frame, center_x: 5.0, center_y: 8.0, diameter: 4.0) }
        let(:id) { circle.id }
        let(:circle_params) { { center_x: 10.0, center_y: 15.0, diameter: 8.0 } }
        let(:raw_post) { { circle: circle_params }.to_json }
        schema '$ref' => '#/components/schemas/Circle'
        run_test!
      end

      response(404, 'not found') do
        schema '$ref' => '#/components/schemas/Error'
        let(:id) { 99999 }
        let(:circle_params) { { center_x: 10.0, center_y: 15.0, diameter: 8.0 } }
        let(:circle) { { circle: circle_params } }
        let(:raw_post) { circle.to_json }
        run_test!
      end

      response(422, 'unprocessable entity') do
        let!(:frame) { Frame.create!(center_x: 0, center_y: 0, width: 100, height: 100) }
        let!(:circle_record) { Circle.create!(frame: frame, center_x: 5.0, center_y: 8.0, diameter: 4.0) }
        let(:id) { circle_record.id }
        let(:circle_params) { { center_x: nil, center_y: 15.0, diameter: 8.0 } }
        let(:circle) { { circle: circle_params } }
        let(:raw_post) { circle.to_json }
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end

    delete('delete circle') do
      tags 'Circles'
      description 'Remove um círculo'

      response(204, 'no content') do
        let!(:frame) { Frame.create!(center_x: 0, center_y: 0, width: 100, height: 100) }
        let!(:circle) { Circle.create!(frame: frame, center_x: 5.0, center_y: 8.0, diameter: 4.0) }
        let(:id) { circle.id }
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
