FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY . .
RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Force containers to use standard port 80
ENV HTTP_PORTS=80
EXPOSE 80

ENTRYPOINT ["dotnet", "ThoughtService.dll"]
