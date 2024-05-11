Select *
From DabiraPortfolioProject..CovidDeaths
WHERE continent is not null
Order by 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM DabiraPortfolioProject..CovidDeaths
Order by 1,2

SELECT location, date, total_cases, total_deaths,(Total_deaths/total_cases)*100 AS DeathPercentage
FROM DabiraPortfolioProject..CovidDeaths
WHERE Location like '%states%'
and continent is not null
Order by 1,2

SELECT location, date, population, (total_cases/population)*100 as PercentPopulationInfected
FROM DabiraPortfolioProject..CovidDeaths
WHERE Location like '%states%'
Order by 1,2

SELECT location, population, MAX(total_cases) as HighestInfectionCount
FROM DabiraPortfolioProject..CovidDeaths
group by location, population
Order by 1,2

SELECT location, population, Max(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 
	PercentPopulationInfected
FROM DabiraPortfolioProject..CovidDeaths
WHERE continent is not null
group by location, population
Order by PercentPopulationInfected desc

SELECT location,MAX(total_deaths) as TotalDeathCount
FROM DabiraPortfolioProject..CovidDeaths
Group by location
Order by TotalDeathCount desc

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM DabiraPortfolioProject..CovidDeaths
WHERE continent is not null
Group by location
Order by TotalDeathCount desc

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM DabiraPortfolioProject..CovidDeaths
WHERE continent is null
Group by location
Order by TotalDeathCount desc

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM DabiraPortfolioProject..CovidDeaths
WHERE continent is not null
Group by continent
Order by TotalDeathCount desc



SELECT date, total_cases, total_deaths,(Total_deaths/total_cases)*100 AS DeathPercentage
FROM DabiraPortfolioProject..CovidDeaths
--WHERE Location like '%states%'
WHERE continent is not null
Order by 1,2

SELECT date, SUM(new_cases) as totalcases
FROM DabiraPortfolioProject..CovidDeaths
--WHERE Location like '%states%'
Group by date
Order by 1,2

SELECT SUM(new_cases) as totalcases, Sum(cast(new_deaths as int)) as totaldeaths, Sum(cast
	(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
FROM DabiraPortfolioProject..CovidDeaths
WHERE Continent is not null
--Group by date
Order by 1,2


Select *
From DabiraPortfolioProject..CovidDeaths as DTH
Join DabiraPortfolioProject..CovidVaccinations as VAC
	on dth.location = vac.location
	and dth.date = vac.date

Select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations
From DabiraPortfolioProject..CovidDeaths as DTH
Join DabiraPortfolioProject..CovidVaccinations as VAC
	on dth.location = vac.location
	and dth.date = vac.date
WHERE dth.continent is not null
Order by 2,3

Select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dth.location order by dth.location, 
  dth.date) as Rollingpeoplevaccinated
From DabiraPortfolioProject..CovidDeaths as DTH
Join DabiraPortfolioProject..CovidVaccinations as VAC
	on dth.location = vac.location
	and dth.date = vac.date
WHERE dth.continent is not null
Order by 2,3

WITH PopsvsVac (continent,location, date, population, new_vaccinations,Rollingpeoplevaccinated)
as
(
Select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dth.location order by dth.location, 
  dth.date) as Rollingpeoplevaccinated
From DabiraPortfolioProject..CovidDeaths as DTH
Join DabiraPortfolioProject..CovidVaccinations as VAC
	on dth.location = vac.location
	and dth.date = vac.date
WHERE dth.continent is not null
--Order by 2,3
)
Select *, (Rollingpeoplevaccinated/population)*100
From PopsvsVac

DROP TABLE IF EXISTS #Percentpopulationvaccinated2
Create table #Percentpopulationvaccinated2
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rollingpeoplevaccinated numeric
)

Insert into #Percentpopulationvaccinated2
Select dth.continent, dth.location,dth.date, dth.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dth.location order by dth.location,
  dth.date) as RollingPeoplevaccinated
From Dabiraportfolioproject..CovidDeaths as dth
Join Dabiraportfolioproject..Covidvaccinations as vac
	On dth.location = vac. location
	and dth.date = vac.date
where dth.continent is not null
--Order by 2,3

Select *, (Rollingpeoplevaccinated/population)*100
From #Percentpopulationvaccinated2

Create View Percentpopulationvaccinated2 as
Select dth.continent, dth.location,dth.date, dth.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dth.location order by dth.location,
  dth.date) as RollingPeoplevaccinated
From Dabiraportfolioproject..CovidDeaths as dth
Join Dabiraportfolioproject..Covidvaccinations as vac
	On dth.location = vac. location
	and dth.date = vac.date
where dth.continent is not null
--order by 2,3






