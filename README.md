# Rails Frames and Circles Api

![Rails image](public/rails.png)

**About**

The Frames and Circles API is a Ruby on Rails (API-only) project for managing geometric frames and circles, enforcing strict spatial and geometric rules. It provides a RESTful interface for creating, updating, and querying frames and circles, ensuring circles never touch each other within the same frame, always fit entirely within their parent frame, and frames themselves do not touch or intersect. All measurements are in centimeters, supporting decimal values for precision.

[Project Homepage](https://github.com/enogrob/rails_frames_and_circles_api)

## Contents

- [Summary](#summary)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [Usage Examples](#usage-examples)
- [Contributing Guidelines](#contributing-guidelines)
- [Troubleshooting](#troubleshooting)
- [License](#license)
- [References](#references)

## Summary


The Frames and Circles API is a robust Ruby on Rails (API-only) application designed to manage geometric frames and circles with strict spatial and geometric rules. Its primary purpose is to provide a reliable RESTful interface for creating, updating, deleting, and querying frames and circles, ensuring high data integrity and adherence to business logic.

Key features include:
- Circles must never touch each other within the same frame.
- Circles must always fit entirely within their parent frame.
- Frames themselves do not touch or intersect.
- All measurements are expressed in centimeters, supporting decimal values for precision.
- Business logic is encapsulated in service objects for maintainability and testability.
- Comprehensive model validations enforce geometric constraints at the data layer.
- API endpoints are documented with Swagger/OpenAPI for easy integration and exploration.
- Full test coverage is provided via RSpec, ensuring reliability and confidence in the codebase.
- The project is containerized with Docker Compose and uses PostgreSQL for persistent storage, making it suitable for both local development and production deployment.

This API is ideal for technical assessments, geometric modeling applications, and any use case requiring strict spatial constraints and high data integrity. Its clear separation of concerns, modern Rails practices, and thorough documentation make it a strong example of best practices in Rails API development.

## Architecture

The API is structured with:

- **Models**: Frame, Circle
- **Service Objects**: Encapsulate business logic for creation, deletion, querying, and updating
- **Controllers**: RESTful endpoints for frames and circles
- **Database**: PostgreSQL (Docker Compose), SQLite (optional for local dev)
- **API Documentation**: Swagger/OpenAPI via RSwag

```mermaid
graph TD
    subgraph API_Layer[API Layer]
        FramesController
        CirclesController
    end
    subgraph Models[Models]
        Frame
        Circle
    end
    subgraph Services[Services]
        FrameCreationService
        FrameDeletionService
        CircleCreationService
        CircleDeletionService
        CircleQueryService
        CircleUpdateService
    end
    subgraph Database[Database]
        PostgreSQL[(PostgreSQL)]
    end

    FramesController --> Frame
    FramesController --> FrameCreationService
    FramesController --> FrameDeletionService
    CirclesController --> Circle
    CirclesController --> CircleCreationService
    CirclesController --> CircleDeletionService
    CirclesController --> CircleQueryService
    CirclesController --> CircleUpdateService
    Frame --> PostgreSQL
    Circle --> PostgreSQL
```

<details>
<summary><strong>1. Gems Dependency Diagram - Dependencies and Models</strong> (Click to expand)</summary>

```mermaid
graph TD
    subgraph "Core Gems"
        Rails[Rails 8.0.2]
        RSpec[RSpec 8.0]
        RSwag[RSwag 2.16]
        Brakeman[Brakeman]
        SimpleCov[SimpleCov]
        Puma[Puma]
        Thruster[Thruster]
        Rubocop[Rubocop]
    end

    subgraph "Models"
        Frame
        Circle
    end

    Rails --> Frame
    Rails --> Circle
    RSpec --> Frame
    RSpec --> Circle
    RSwag --> Rails
    Brakeman --> Rails
    SimpleCov --> RSpec
```
</details>

<details>
<summary><strong>2. Dependencies and Models</strong> (Click to expand)</summary>

```mermaid
classDiagram
    class Frame {
        +center_x: float
        +center_y: float
        +width: float
        +height: float
        +has_many: circles
    }
    class Circle {
        +center_x: float
        +center_y: float
        +diameter: float
        +belongs_to: frame
    }
    Frame "1" --> "*" Circle : contains
```
</details>

<details>
<summary><strong>3. Mind Map - Interconnected Themes</strong> (Click to expand)</summary>

```mermaid
mindmap
  root((Frames and Circles API))
    Models
      Frame
      Circle
    Services
      FrameCreationService
      FrameDeletionService
      CircleCreationService
      CircleDeletionService
      CircleQueryService
      CircleUpdateService
    API
      FramesController
      CirclesController
      Endpoints
    Database
      PostgreSQL
    Testing
      RSpec
      SimpleCov
    Documentation
      Swagger
      RSwag
    Deployment
      Docker
      Docker Compose
```
</details>

<details>
<summary><strong>4. Deployment Architecture</strong> (Click to expand)</summary>

```mermaid
graph TD
User[User]
Web[Web Container Rails API]
DB[PostgreSQL Container]
Swagger[Swagger UI]
RSpec[Testing]
DockerCompose[Docker Compose]

User --> Web
Web --> DB
Web --> Swagger
Web --> RSpec
Web --> DockerCompose
```
</details>

<details>
<summary><strong>5. Git Graph - Project Evolution</strong> (Click to expand)</summary>

```mermaid
gitGraph
commit id: "rails-initial-setup"
commit id: "rspec-initial-setup"
commit id: "model-initial-setup"
commit id: "service-initial-setup"
commit id: "controller-routes-initial-setup"
commit id: "add-tests"
commit id: "add-docker-and-docker-compose"
commit id: "add-simplecov"
commit id: "add-readme"
commit id: "improved-validation"
commit id: "swagger-setup"
commit id: "finalize-api"
```
</details>

## Tech Stack

- Ruby 3.2.2
- Rails 8.0.2 (API-only)
- PostgreSQL
- RSpec, SimpleCov
- RSwag (Swagger/OpenAPI)
- Docker, Docker Compose
- Brakeman, Rubocop

## Getting Started

1. Clone the repository:
   ```sh
   git clone git@github.com:enogrob/rails_frames_and_circles_api.git
   cd rails_frames_and_circles_api
   ```
2. Set up environment variables (RAILS_MASTER_KEY from `config/master.key`)
3. Build and start containers:
   ```sh
   docker compose build
   docker compose up
   ```
4. Set up the database:
   ```sh
   docker compose exec web bin/rails db:setup
   docker compose exec web bin/rails db:test:prepare
   docker compose exec web bin/rails db:migrate RAILS_ENV=test
   ```
5. Run tests:
   ```sh
   docker compose exec web bundle exec rspec
   ```
6. Access the API at [http://localhost:3000](http://localhost:3000)
7. View Swagger docs at `/api-docs`

## Usage Examples

**Create a Frame**
```sh
curl -X POST http://localhost:3000/api/v1/frames \
  -H "Content-Type: application/json" \
  -d '{"center_x": 0, "center_y": 0, "width": 10, "height": 10}'
```

**Add a Circle to a Frame**
```sh
curl -X POST http://localhost:3000/api/v1/frames/1/circles \
  -H "Content-Type: application/json" \
  -d '{"center_x": 1, "center_y": 1, "diameter": 2}'
```

**List Circles in a Frame**
```sh
curl http://localhost:3000/api/v1/frames/1/circles
```

**Delete a Frame**
```sh
curl -X DELETE http://localhost:3000/api/v1/frames/1
```

## Contributing Guidelines

- Fork the repository and create a feature branch
- Follow Ruby and Rails style guides (Rubocop enforced)
- Write RSpec tests for new features and bug fixes
- Submit pull requests with clear descriptions
- Report issues via GitHub Issues
- Ensure all tests pass before submitting changes

## Troubleshooting

**403 Blocked Host error:** Add `config.hosts << "www.example.com"` to `config/environments/test.rb`.

**Database adapter error (pg not found):** Add `gem "pg"` to your Gemfile and rebuild Docker.

**Container fails to start:** Check logs with `docker compose logs web` and ensure all environment variables are set.

## License

MIT License (see LICENSE file)

## References

- [Project Requirements](src/requirements.md)
- [Rails Guides](https://guides.rubyonrails.org/)
- [RSwag](https://github.com/rswag/rswag)
- [Docker Compose Docs](https://docs.docker.com/compose/)
- [RSpec](https://rspec.info/)
