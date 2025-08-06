require "rswag/ui"

Rswag::Ui.configure do |c|
  c.swagger_endpoint "/api-docs/v1/swagger.yaml", "Frames and Circles API V1"
end
