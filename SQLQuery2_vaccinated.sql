select * from Portfolio_project..covid_death
order by 2,3;



--select * from Portfolio_project..covid_vaccination
--order by 2,3;
--select the data that we are deaing with
--select location,date,total_cases,new_cases,total_deaths
--from Portfolio_project..covid_death
--order by 1,2;
--looking at total_cases vs total_deaths
--Is the likelihood of dying if you contracted covid from yuor country
select location,date,total_cases,(total_deaths/total_cases)*100 as death_percentage
from Portfolio_project..covid_death
where continent like'%Asia'AND continent IS NOT NULL
order by 1,2;


--looking at total_cases vs  population
select location,population,total_cases,(total_cases/population)*100 as infected_percentage
from Portfolio_project..covid_death
where continent like'%Asia'
AND continent IS NOT NULL
order by 1,2;
--countries with high infectious rate with respect to population
select location,population,max(total_cases)as highest_infectious_country,max(total_cases/population)*100 as infected_percentage
from Portfolio_project..covid_death
WHERE continent IS NOT NULL
group by location,population
order by infected_percentage desc;



--Countries with highest deathe count per population
select location,max(total_deaths) as max_death
from Portfolio_project..covid_death
WHERE continent IS NOT NULL
group by location
order by max_death desc;



select * from Portfolio_project..covid_death
WHERE continent IS NOT NULL
order by 2,3;

--LETS Analyse things by continent

select continent,max(total_deaths) as max_death
from Portfolio_project..covid_death
WHERE continent IS  NULL
group by continent
order by max_death desc;

--continents with highest death name

select continent,max(total_deaths) as max_death
from Portfolio_project..covid_death
WHERE continent IS  not NULL
group by continent
order by max_death desc;
-- we are looking into globally
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from Portfolio_project..covid_death
where continent like'%Asia'AND continent IS NOT NULL
order by 1,2;

--with respect to date we are looking for new cases
--select date, SUM(new_cases),sum(cast(new_deaths as int)),SUM(cast(new_deaths as int))/SUM(new_cases)*100
--from Portfolio_project..covid_death
----where continent like'%Asia'
--group by date
--order by 1,2;
-------------------vaccination Analysis----------------------------------------------------------------
--------Total population vs vaccination------
select * from Portfolio_project..covid_death dea
join Portfolio_project..covid_vaccination  vacc
on dea.location=vacc.location
and  dea.date=vacc.date
-----Looking for total population vs vaccination
select dea.continent,dea.location,dea.date,dea.population from Portfolio_project..covid_death dea
join Portfolio_project..covid_vaccination  vacc
on dea.location=vacc.location
and  dea.date=vacc.date
order by 2,3
select cast(new_vaccinations as  bigint) from
Portfolio_project..covid_vaccination_edited;
select cast(new_cases_smoothed as bigint)from Portfolio_project..covid_vaccination

---vaccination analysis
select dea.continent,dea.location,dea.date,dea.population,cast(vacc.new_vaccinations as bigint) as vaccinated from Portfolio_project..covid_death dea
join Portfolio_project..covid_vaccination  vacc
on dea.location=vacc.location
and  dea.date=vacc.date
order by 2,3
select cast(new_cases_smoothed as bigint)from Portfolio_project..covid_vaccination


ALTER TABLE Portfolio_project..covid_vaccination
ALTER COLUMN new_vaccinations float
---------------population vs vaccinations---------
select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations from Portfolio_project..covid_death dea
join Portfolio_project..covid_vaccination  vacc
on dea.location=vacc.location
and  dea.date=vacc.date
select new_vaccinations_smoothed from Portfolio_project..covid_vaccination
ALTER TABLE Portfolio_project..covid_vaccination
ALTER COLUMN tests_per_case float
select life_expectancy,population from Portfolio_project..covid_vaccination



select * from Portfolio_project..covid_vaccination; 
select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations from Portfolio_project..covid_death dea
join Portfolio_project..covid_vaccination  vacc
on dea.location=vacc.location
and  dea.date=vacc.date
------------------------------------------------------------------
select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
SUM(convert(bigint,vacc.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
as rolling_ppl_vaccinated
from Portfolio_project..covid_death dea
join Portfolio_project..covid_vaccination  vacc
on dea.location=vacc.location
and dea.date=vacc.date
where dea.continent is not null
------------------------------------------------------------------------------------------







----------------------------------------------------
With popvsvacc(Continent,Location,Date,Popularisation,New_vaccinations,rolling_ppl_vaccinated)
as
(

select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
SUM(convert(bigint,vacc.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
as rolling_ppl_vaccinated
from Portfolio_project..covid_death dea
join Portfolio_project..covid_vaccination  vacc
on dea.location=vacc.location
and dea.date=vacc.date
where dea.continent is not null
)
select * from popvsvacc
-----------------Create Table--------------
Drop Table if exists #percentage_vaccination
create table #percentage_vaccination
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
rolling_ppl_vaccinated numeric
)
Insert into #percentage_vaccination
select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
SUM(convert(bigint,vacc.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
as rolling_ppl_vaccinated
from Portfolio_project..covid_death dea
join Portfolio_project..covid_vaccination  vacc
on dea.location=vacc.location
and dea.date=vacc.date
where dea.continent is not null
select *,(rolling_ppl_vaccinated/ population)*100 from #percentage_vaccination
----------------------------------------------------------------------------------------
--------Creating view to store data for later-------------
--------------------------------------------------------------------------------------
Create view percentage_vaccination as
select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
SUM(convert(bigint,vacc.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
as rolling_ppl_vaccinated
from Portfolio_project..covid_death dea
join Portfolio_project..covid_vaccination  vacc
on dea.location=vacc.location
and dea.date=vacc.date
where dea.continent is not null
---------
select * from percentage_vaccination


