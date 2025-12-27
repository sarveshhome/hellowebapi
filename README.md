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

## Azure Pipeline Configuration

```yaml
trigger:
  branches:
    include:
    - main

variables:
- name: solution
  value: '**/*.sln'
- name: buildPlatform
  value: 'Any CPU'
- name: buildConfiguration
  value: 'Release'

stages:

# ===================== CI STAGE =====================
- stage: Build
  displayName: 'CI - Build, Test & Publish'
  jobs:
  - job: BuildJob
    pool:
      vmImage: 'windows-latest'
    steps:
    - task: NuGetToolInstaller@1

    - task: NuGetCommand@2
      inputs:
        restoreSolution: '$(solution)'

    # Build only (NO WebDeploy)
    - task: VSBuild@1
      inputs:
        solution: '$(solution)'
        platform: '$(buildPlatform)'
        configuration: '$(buildConfiguration)'

    - task: VSTest@2
      inputs:
        platform: '$(buildPlatform)'
        configuration: '$(buildConfiguration)'

    # ZIP Deploy–compatible publish
    - task: DotNetCoreCLI@2
      displayName: 'Publish Web App (ZIP Deploy)'
      inputs:
        command: 'publish'
        publishWebProjects: true
        arguments: '--configuration $(buildConfiguration) --output $(Build.ArtifactStagingDirectory)'
        zipAfterPublish: true

    - task: PublishBuildArtifacts@1
      inputs:
        pathToPublish: '$(Build.ArtifactStagingDirectory)'
        artifactName: 'drop'

# ===================== CD STAGE =====================
- stage: Deploy_Dev
  displayName: 'CD - Deploy to Dev'
  dependsOn: Build
  condition: succeeded()

  jobs:
  - deployment: DeployDev
    displayName: 'Deploy to Azure App Service'
    environment: dev
    pool:
      vmImage: 'windows-latest'

    strategy:
      runOnce:
        deploy:
          steps:
          - download: current
            artifact: drop

          - task: AzureWebApp@1
            displayName: 'ZIP Deploy to Azure App Service'
            inputs:
              azureSubscription: 'cdHelloWorldAPI_dev'
              appName: 'helloworldsarvesh'
              package: '$(Pipeline.Workspace)/drop/**/*.zip'
```
