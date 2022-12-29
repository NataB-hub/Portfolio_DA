-- Covid-19. Data Exploration. 

-- Select data that we are going to be starting with

SELECT location, population, date, total_cases, new_cases, total_deaths
FROM PortfolioProject..CovidDeath
WHERE continent IS NOT NULL
ORDER BY location, date

-- Total Cases vs Total Death
-- Shows likelihood of dying by location(country)

SELECT location, population, ROUND((MAX(CAST(total_deaths AS Int))/MAX(total_cases))*100, 2) AS DeathPercentage
FROM PortfolioProject..CovidDeath
WHERE continent IS NOT NULL
--AND location LIKE '%finland%'
GROUP BY location, population
ORDER BY location

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid-19 by date

SELECT location, population, date, total_cases, new_cases, total_deaths, ROUND((total_cases/population)*100,2) AS CasesPercentage
FROM PortfolioProject..CovidDeath
WHERE continent IS NOT NULL
--AND location LIKE '%finland%'
ORDER BY location, date

-- Top-10 of countries with the Highest Infection Rate compared to Population

SELECT TOP 10 location, population, MAX(total_cases) AS TotalCases, ROUND((MAX(total_cases)/population)*100, 2) AS PercentPopulationInfected
FROM PortfolioProject..CovidDeath
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

-- Top-10 countries with the Highest Death Count

SELECT TOP 10 location, population, MAX(total_cases) AS TotalCases, MAX(CAST(total_deaths AS Int)) AS DeathCount, ROUND((MAX(CAST(total_deaths AS Int))/MAX(total_cases))*100, 2) AS PercentCasesDeath
FROM PortfolioProject..CovidDeath
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY DeathCount DESC

-- Top-10 counries with the Highest Death Count per Population

SELECT TOP 10 location, population, MAX(total_cases) AS TotalCases, MAX(CAST(total_deaths AS Int)) AS DeathCount, ROUND((MAX(CAST(total_deaths AS Int))/MAX(total_cases))*100, 2) AS PercentPopulationDeath
FROM PortfolioProject..CovidDeath
WHERE continent IS NOT NULL
AND location <> 'North Korea' -- strange numbers TotalCases = 1 DeathCount = 6
GROUP BY location, population
ORDER BY PercentPopulationDeath DESC

-- Looking at the whole world and continents

-- Shows total death count
SELECT location, population, MAX(CAST(total_deaths AS Int)) AS TotalDeathCount, ROUND((MAX(CAST(total_deaths AS Int))/population)*100, 2) AS PercentPopulationDeath
FROM PortfolioProject..CovidDeath
WHERE continent IS NULL
GROUP BY location, population
ORDER BY TotalDeathCount DESC

-- Shows likelihood of dying by the World or the continent

WITH TotalDeathPercentage (location, population, DeathPercentage)
AS
(
SELECT location, population, ROUND((MAX(CAST(total_deaths AS Int))/MAX(total_cases))*100, 2) AS DeathPercentage
FROM PortfolioProject..CovidDeath
WHERE continent IS NULL
GROUP BY location, population
--ORDER BY location
)
SELECT location, population, DeathPercentage
FROM TotalDeathPercentage
--WHERE DeathPercentage > 100

-- Show new_cases and new_deaths by date

SELECT date, SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS Int)) AS TotalDeaths
FROM PortfolioProject..CovidDeath
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date

-- Total Vaccinations by country

WITH PopsVac (continent, location, population, TotalVaccinations)
as
(
SELECT dea.continent, dea.location, dea.population,
MAX(CAST(vac.people_fully_vaccinated AS bigint)) AS TotalVaccinations
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac 
	ON dea.location=vac.location
WHERE dea.continent IS NOT NULL
GROUP BY dea.continent, dea.location, dea.population
)
SELECT *, ROUND((TotalVaccinations/Population)*100, 2) AS PercentageVac
FROM PopsVac
ORDER BY PercentageVac DESC

-- Create a table

DROP Table if exists PercentVaccinations
Create Table PercentVaccinations
(
continent nvarchar(255),
location nvarchar(255),
population numeric,
TotalVaccinations bigint
)

Insert Into PercentVaccinations (continent, location, population, TotalVaccinations)
SELECT dea.continent, dea.location, dea.population,
MAX(CAST(vac.people_fully_vaccinated AS bigint)) AS TotalVaccinations
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac 
	ON dea.location=vac.location
WHERE dea.continent IS NOT NULL
GROUP BY dea.continent, dea.location, dea.population


SELECT *, ROUND((TotalVaccinations/population)*100, 1) AS PercentageVac
FROM PercentVaccinations
ORDER BY location


 -- CREATE VIEW


USE PortfolioProject;
GO
CREATE VIEW PercentageVaccinations AS
WITH PopsVac (continent, location, population, TotalVaccinations)
as
(
SELECT dea.continent, dea.location, dea.population,
MAX(CAST(vac.people_fully_vaccinated AS bigint)) AS TotalVaccinations
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac 
	ON dea.location=vac.location
WHERE dea.continent IS NOT NULL
GROUP BY dea.continent, dea.location, dea.population
)
SELECT continent, location, population, TotalVaccinations, ROUND((TotalVaccinations/Population)*100, 2) AS PercentageVac
FROM PopsVac
--ORDER BY PercentageVac DESC



 