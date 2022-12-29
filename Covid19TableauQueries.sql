--Queries for Tableau project

-- 1 Global numbers: total_cases, total_deaths, deaths_percentage
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, ROUND((SUM(CAST(new_deaths AS int))/SUM(new_cases))*100, 2) AS DeathPercentage
FROM PortfolioProject..CovidDeath
WHERE continent IS NOT NULL


-- 2 Shows total death count by continent

SELECT location, SUM(CAST(new_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeath
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union', 'High income', 'International', 'Low income', 'Lower middle income', 'Upper middle income')
GROUP BY location
ORDER BY location

-- 3 Highest Infection Count by location and Percent Population Infected by location

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, ROUND((MAX(total_cases)/population)*100, 2) AS PercentPopulationInfected
FROM PortfolioProject..CovidDeath
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentPopulationInfected desc

-- 4 Highest Infection Count by location and Percent Population Infected by location and date

SELECT location, population, date, MAX(total_cases) AS HighestInfectionCount, ROUND((MAX(total_cases)/population)*100, 2) AS PercentPopulationInfected
FROM PortfolioProject..CovidDeath
WHERE continent IS NOT NULL
GROUP BY location, population, date
ORDER BY PercentPopulationInfected desc
