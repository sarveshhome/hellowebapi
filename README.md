# Hello Web API

A simple .NET Web API with a `/hello` endpoint.

## Prerequisites
- .NET 9.0 SDK
- Docker (optional)

## Running Locally

1. Restore dependencies:
   ```bash
   dotnet restore
   ```

2. Run the application:
   ```bash
   dotnet run
   ```

3. Access the endpoint:
   - URL: `http://localhost:5269/hello` (port may vary, check console output)

## Deployment with Docker

1. Build the Docker image:
   ```bash
   docker build -t hello-webapi .
   ```

2. Run the container:
   ```bash
   docker run -p 8080:8080 hello-webapi
   ```

3. Access the endpoint:
   - URL: `http://localhost:8080/hello`
