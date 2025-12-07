# Use the official ASP.NET Core runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 8080

# Use the SDK image for building the app
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["HelloWebApi.csproj", "."]
RUN dotnet restore "./HelloWebApi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "HelloWebApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "HelloWebApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HelloWebApi.dll"]
