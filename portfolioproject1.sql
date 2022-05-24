-- Data explortion in SQL
--Covid-19 Portfolio Project

select* from Portfolio..[covidvaccinations]

select* from Portfolio..[coviddeaths]

select* from Portfolio..[covidvaccinations]
Where continent is not null
order by 3,4

select* from Portfolio..[coviddeaths]
Where continent is not null
order by 3,4

-- selecting data that are want to use

select location, date,total_cases,new_cases,total_deaths,population
from Portfolio..[coviddeaths]
Where continent is not null
order by 1,2

-- death rate (Total death vs total case)

select location, date,total_cases,total_deaths,((total_deaths/total_cases)*100) as death_rate
from Portfolio..[coviddeaths]
--where location='India and Where continent is not null
order by 1,2 
 

--Showing percantge people get affected by covid(total cases vs population)

select location, date,total_cases,population,((total_cases/population)*100) as infection_rate
from Portfolio..[coviddeaths]
--where location='India'  
Where continent is not null
order by 1,2 

--Countries with highest infection rate

select location,population,max(total_cases) as highest_infection,max(((total_cases/population)*100)) as infection_rate
from Portfolio..[coviddeaths]
Where continent is not null
group by location,population
order by 4 desc

--Countries with highest deaths

select location,max(cast(total_deaths as bigint)) as highest_death
from Portfolio..[coviddeaths]
Where continent is not null
group by location
order by 2 desc

-- Break down of highest deaths by continent

select continent,max(cast(total_deaths as bigint)) as highest_death
from Portfolio..[coviddeaths]
Where continent is not null
group by continent
order by 2 desc

-- Global number of covid cases and deaths by continents
select date,sum(cast(new_deaths as int)) as total_deathbydate,sum(new_cases) as total_casesbydate,  (sum(cast(new_deaths as int))/sum(new_cases)*100) as death_rate_globally
from Portfolio..[coviddeaths]
Where continent is not null
group by date
order by 1

--Overall global numbers of covid cases and deaths

select sum(cast(new_deaths as int)) as total_deathbydate,sum(new_cases) as total_casesbydate,  (sum(cast(new_deaths as int))/sum(new_cases)*100) as death_rate_globally
from Portfolio..[coviddeaths]
Where continent is not null

--joining both tables

select*
from Portfolio..[coviddeaths] as deaths
join Portfolio..[covidvaccinations] as vaccinations
on deaths.location=vaccinations.location
and deaths.date=vaccinations.date
Where deaths.continent is not null
order by 4

--Looking for Total vaccinated people vs Total population

select deaths.continent,deaths.location,deaths.date,deaths.population,vaccinations.new_vaccinations,
sum(cast(vaccinations.new_vaccinations as bigint)) over (partition by deaths.location order by deaths.location,deaths.date ) as vaccinations_record
from Portfolio..[coviddeaths]  as deaths
join Portfolio..[covidvaccinations]  as vaccinations
on deaths.location=vaccinations.location
and deaths.date=vaccinations.date
Where deaths.continent is not null
order by 2,3

--CTE method

with popvsvacc (continent,location,date,population,new_vaccinations,vaccinations_record)
as
(
select deaths.continent, deaths.location, deaths.date, deaths.population, vaccinations.new_vaccinations,
sum(cast(vaccinations.new_vaccinations as bigint)) over (partition by deaths.location order by deaths.location,deaths.date ) as vaccinations_record
from Portfolio..[coviddeaths] as deaths
join Portfolio..[covidvaccinations] as vaccinations
on deaths.location=vaccinations.location
and deaths.date=vaccinations.date
Where deaths.continent is not null
)
select* ,(vaccinations_record/population)*100 as vaccinated_percentage
from popvsvacc

--Temp Table

Create table populationvsvaccinations
(
continent nvarchar (250),
location nvarchar (250),
date datetime,
population numeric,
new_vaccinations numeric,
vaccinations_record numeric)
insert into populationvsvaccinations
select deaths.continent, deaths.location, deaths.date, deaths.population, vaccinations.new_vaccinations,
sum(cast(vaccinations.new_vaccinations as bigint)) over (partition by deaths.location order by deaths.location,deaths.date ) as vaccinations_record
from Portfolio..[coviddeaths] as deaths
join Portfolio..[covidvaccinations] as vaccinations
on deaths.location=vaccinations.location
and deaths.date=vaccinations.date

select*, (vaccinations_record/population)*100 as vaccinated_percentage
from populationvsvaccinations

-- Create view

Create View percentagepopulationvaccinated as
select deaths.continent, deaths.location, deaths.date, deaths.population, vaccinations.new_vaccinations,
sum(cast(vaccinations.new_vaccinations as bigint)) over (partition by deaths.location order by deaths.location,deaths.date ) as vaccinations_record
from Portfolio..[coviddeaths] as deaths
join Portfolio..[covidvaccinations] as vaccinations
on deaths.location=vaccinations.location
and deaths.date=vaccinations.date
Where deaths.continent is not null



