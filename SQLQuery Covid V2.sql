select *
from Portfolioproject.dbo.coviddeaths

select *
from portfolioproject.dbo.covidvaccinations

select *
from Portfolioproject..coviddeaths
Where continent is not null
order by 3,4

--select *
--from portfolioproject..covidvaccinations
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from Portfolioproject..coviddeaths
order by 1,2

-- Looking at Total_Cases Vs Total_Deaths
-- Shows the likelihood of dying if you contract covid in your country
select Location, Date, Total_cases, Total_deaths, (Total_deaths/Total_cases)*100 as DeathPercentage
from Portfolioproject..coviddeaths
order by 1,2

select Location, Date, Total_cases, Total_deaths, (Total_deaths/Total_cases)*100 as DeathPercentage
from Portfolioproject..coviddeaths
where location like '%states%'
order by 1,2

select Location, Date, Total_cases, Total_deaths, (Total_deaths/Total_cases)*100 as DeathPercentage
from Portfolioproject..coviddeaths
where location like 'nigeria%'
order by 1,2

--Looking at the Total_Cases Vs Population
--shows what percentage of population got covid

select Location, Date, Population, Total_cases, (Total_cases/Population)*100 as PercentPopulationInfected
from Portfolioproject..coviddeaths
where location like '%states%'
order by 1,2

select Location, Date, Population, Total_cases, (Total_cases/Population)*100 as PercentPopulationInfected
from Portfolioproject..coviddeaths
where location like 'nigeria%'
order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population

select Location, Population, MAX(Total_cases) as HighestInfectionCount, MAX((Total_cases/Population))*100 as PercentPopulationInfected
from Portfolioproject..coviddeaths
--where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

select Location, Population, MAX(Total_cases) as HighestInfectionCount, MAX((Total_cases/Population))*100 as PercentPopulationInfected
from Portfolioproject..coviddeaths
where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected



select Location, Population, MAX(Total_cases) as HighestInfectionCount, MAX((Total_cases/Population))*100 as PercentPopulationInfected
from Portfolioproject..coviddeaths
where location like 'nigeria%'
Group by Location, Population
order by PercentPopulationInfected 

-- Showing Countries with the Highest Death Count Per Population

select Location, MAX(cast(Total_deaths as int)) AS TotalDeathCount
from Portfolioproject..coviddeaths
--where location like 'nigeria%'
where continent is not null
Group by Location
order by TotalDeathCount desc

-- Showing Continents with Highest Death Count per Population

select Continent, MAX(cast(Total_deaths as int)) AS TotalDeathCount
from Portfolioproject..coviddeaths
--where location like 'nigeria%'
where continent is not null
Group by Continent
order by TotalDeathCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT

select Location, MAX(cast(Total_deaths as int)) AS TotalDeathCount
from Portfolioproject..coviddeaths
--where location like 'nigeria%'
where continent is null
Group by Location
order by TotalDeathCount desc

-- GLOBAL NUMBERS

select Date, Sum(New_cases) --Total_deaths, (Total_deaths/Total_cases)*100 as DeathPercentage
from Portfolioproject..coviddeaths
--where location like 'nigeria%'
Group by date 
order by 1,2

select Date, Sum(New_cases), Sum(cast(new_deaths as int)) --Total_deaths, (Total_deaths/Total_cases)*100 as DeathPercentage
from Portfolioproject..coviddeaths
--where location like 'nigeria%'
Group by date 
order by 1,2

Select Date, Sum(New_cases) as total_cases,  Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from Portfolioproject..coviddeaths
--where location like 'nigeria%'
where continent is not null
Group by date 
order by 1,2

Select Sum(New_cases) as total_cases,  Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from Portfolioproject..coviddeaths
--where location like 'nigeria%'
where continent is not null
--Group by date 
order by 1,2

select *
from PortfolioProject..CovidVaccinations

select *
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date =vac.date

-- Looking at Total population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date =vac.date

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date =vac.date
where dea.continent is not null
order by 2, 3

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date =vac.date
where dea.continent is not null
order by 2, 3

-- USE CTE

with PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date =vac.date
where dea.continent is not null
--order by 2, 3
)
Select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac

-- TEMP TABLE

CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated  numeric
)
INSERT Into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date =vac.date
where dea.continent is not null
--order by 2, 3
Select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated  numeric
)
INSERT Into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date =vac.date
-- where dea.continent is not null
--order by 2, 3
Select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

-- Creating Views to Store data for later visualizations

Create View PercentPopulationVaccinated3 as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date =vac.date
where dea.continent is not null
--order by 2, 3

select *
from PercentPopulationVaccinated3