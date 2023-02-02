---select * from PortfolioProject..covid_deaths_data$
---order by 3,4

---select * from PortfolioProject..vaccination_data$
---order by 3,4

----Select data that we are goinf to be using

select Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..covid_deaths_data$
where continent is not NULL
order by 1,2;

----total cases vs total deaths
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..covid_deaths_data$
where location like '%states%'
AND continent is not NULL
order by 1,2;

----total cases vs population
select Location, date, total_cases, total_deaths, (total_cases/population)*100 as CovidPercentage
FROM PortfolioProject..covid_deaths_data$
where location like '%states%'
AND continent is not NULL
order by 1,2;

---countries with highest infection rates compare to population
select Location, population,  MAX(total_cases) as MAX_cases, MAX(total_cases/population)*100 as Maxcovid_percentage
FROM PortfolioProject..covid_deaths_data$
---where location like '%states%'
where continent is not NULL
Group By location,population
order by Maxcovid_percentage desc;



---countries with highest death count per population 
select Location, MAX(cast(Total_deaths as int))  as TotalDeathCount 
FROM PortfolioProject..covid_deaths_data$
---where location like '%states%'
where continent is not NULL
Group By location
order by TotalDeathCount desc;


---continents with highest death count per population 
select continent, MAX(cast(Total_deaths as int))  as TotalDeathCount 
FROM PortfolioProject..covid_deaths_data$
---where location like '%states%'
where continent is not NULL
Group By continent
order by TotalDeathCount desc;


---Global numbers

select date, SUM(new_cases) as TotalCases,SUM(cast(new_deaths as int )) as TotalDeaths, SUM(cast(new_deaths as int ))/SUM(New_cases)*100 as DeathPercentage
FROM PortfolioProject..covid_deaths_data$
---where location like '%states%'
where continent is not NULL
group by date
order by 1,2;

---Total population vs vaccinations 

select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations 

from PortfolioProject..covid_deaths_data$ dea
join
PortfolioProject..vaccination_data$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 1,2,3


---USE CTE
with PopvsVac (continent,location,date,New_vaccinations, population)
as
(
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations 

from PortfolioProject..covid_deaths_data$ dea
join
PortfolioProject..vaccination_data$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 1,2,3
)

select * from PopvsVac



---TEMP Table
drop table if exists #Percentpopulationvaccinated
CREATE Table #Percentpopulationvaccinated
(continent nvarchar(255),
Location nvarchar(255),
date datetime,
Population numeric,
New_vaccinations numeric)

INSERT into #Percentpopulationvaccinated

select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations 

from PortfolioProject..covid_deaths_data$ dea
join
PortfolioProject..vaccination_data$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 1,2,3
select * from #Percentpopulationvaccinated



----creating View  to store data for visualization

Create View PercentpopulationVaccinated as 
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations 

from PortfolioProject..covid_deaths_data$ dea
join
PortfolioProject..vaccination_data$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 1,2,3

select * from PercentpopulationVaccinated 