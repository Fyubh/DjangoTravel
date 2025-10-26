# ===== build =====
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# копируем только csproj, чтобы кешировалось restore
COPY Jango_Travel/*.csproj Jango_Travel/
RUN dotnet restore Jango_Travel/Jango_Travel.csproj

# теперь всё остальное
COPY . .
RUN dotnet publish Jango_Travel/Jango_Travel.csproj -c Release -o /app/publish /p:UseAppHost=false

# ===== runtime =====
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Render слушает 8080
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "Jango_Travel.dll"]
