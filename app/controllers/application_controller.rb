class ApplicationController < ActionController::API
  include Response

  config.swagger_docs = {
    'v1/swagger.json' => {
      openapi: '3.0.1',
      info: {
        title: 'Your API',
        version: 'v1',
      },
      paths: {},
    },
  }
end
