/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/
select * 
from PortfolioProject.dbo.CovidDeaths

--Selecting data that we are going to use

select location, date, total_cases, new_cases, total_deaths,population
from PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 1,2



-- Total Cases vs Total Deaths

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100  DeathPercentage
From PortfolioProject..CovidDeaths
Where location = 'Australia'
and continent is not null 
order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as 'InfectedPopulation(%)'
From PortfolioProject..CovidDeaths
Where location = 'Australia'
order by 1,2


-- Countries with Highest Infection Rate compared to Population
select location , population, max(total_cases) as HighestInfectedCount, (max(total_cases/population))*100 as HighestInfectionRate
from PortfolioProject.dbo.CovidDeaths
group by location, population
order by 4 desc


-- Countries with Highest Death Count per Population

select location, max(cast(total_deaths as int)) as HighestDeathCount, population
from PortfolioProject.dbo.CovidDeaths
where continent is not null
group by location,population
order by HighestDeathCount desc


-- DEATH RATE BY CONTINENT

select continent, max(convert(int,total_deaths)) as TotalDeathCount
from PortfolioProject.dbo.CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS BY DATE
select date, sum(new_cases) as total_infected, sum(convert(int,new_deaths)) as total_death, (sum(convert(int,new_deaths))/sum(new_cases))*100 as death_percentage
from PortfolioProject.dbo.CovidDeaths
where continent is not null
group by date
order by 1,2


-- SUM OF ALL GLOBAL NUMBERS
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
order by 1,2


-- Vaccination Percentage according to each country
select dea.location ,(SUM(cast(vac.new_vaccinations as int))/dea.population)*100 as Percentage_of_vaccination
from PortfolioProject.dbo.CovidVaccinations vac
join PortfolioProject.dbo.CovidDeaths dea
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
group by dea.location, dea.population
order by  2 desc


-- Total Population vs Vaccinations

select dea.location, (SUM(cast(vac.new_vaccinations as int)))/dea.population*100 Percentage_vaccination
from PortfolioProject.dbo.CovidVaccinations vac
join PortfolioProject.dbo.CovidDeaths dea
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
group by dea.location, dea.population
order by 2 desc



-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


--Using Partion by for RollingPeopleVaccinated
select dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject.dbo.CovidDeaths dea
join PortfolioProject.dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null




-- Creating View to store data for later visualizations
create view PercentPopulationVaccinated as
select dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject.dbo.CovidDeaths dea
join PortfolioProject.dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null




-- Using CTE to perform Calculation on Partition By in previous query

with RollVacPop(Continent,Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent ,dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject.dbo.CovidDeaths dea
join PortfolioProject.dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select *, (RollingPeopleVaccinated/Population)*100 as RollingUpPercentage
from RollVacPop



-- Using Temp Table to perform Calculation on Partition By in previous query
DROP TABLE IF EXISTS #TempTable
CREATE TABLE #TempTable
(Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 NewVaccination numeric,
 RollingPeopleVaccinated numeric
)
Insert into #TempTable
select dea.continent ,dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject.dbo.CovidDeaths dea
join PortfolioProject.dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select *, (RollingPeopleVaccinated/Population)*100  as  RollingUpPercentage
from #TempTable



