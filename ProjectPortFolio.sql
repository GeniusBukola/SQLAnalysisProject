Select *
from PortfolioProject..CovidDeath
Where Continent is not Null

Select *
from PortfolioProject..CovidVaccination

Select *
from PortfolioProject..CovidDeath
Order by 3,4

Select *
from PortfolioProject..CovidVaccination
Order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, Population
From PortfolioProject..CovidDeath 
Order by 1,2

--Total Cases vs Total Death
--Likelihood of dying if Contatacted Covid in Different Country

Select Location, date, total_cases, total_deaths
From PortfolioProject..CovidDeath
Order by 1,2

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From PortfolioProject..CovidDeath
Order by 1,2

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From PortfolioProject..CovidDeath
Where Location Like '%States%'
Order by 1,2

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From PortfolioProject..CovidDeath
Where Location Like '%Nigeria%'
Order by 1,2

--Total Cases vs Population
--Showing the Percentage of Population that got Covid
--Country With Highest Infection rate Compare to Population

Select Location, date, total_cases, Population, (total_cases/Population)*100 As CasePercentage
From PortfolioProject..CovidDeath
Order by 1,2

Select Location, date, total_cases, Population, (total_cases/Population)*100 As CasePercentage
From PortfolioProject..CovidDeath
Where Location Like '%States%'
Order by 1,2

Select Location, Population, Max(total_cases) As HighestInfectionCount, Max((total_cases/Population))*100 As polutionInfectedPercentage
From PortfolioProject..CovidDeath
Group by Location, Population
Order by polutionInfectedPercentage

Select Location, Population, Max(total_cases) As HighestInfectionCount, Max((total_cases/Population))*100 As polutionInfectedPercentage
From PortfolioProject..CovidDeath
Group by Location, Population
Order by polutionInfectedPercentage desc

--Country With Higehest Death Count per Popultion

Select Location, Population, Max(total_deaths) As HighestDeathCount, Max((total_deaths/Population))*100 As polutionDeathPercentage
From PortfolioProject..CovidDeath
Group by Location, Population
Order by polutionDeathPercentage desc

Select Location, Population, Max(total_deaths) As HighestTotalDeathCount
From PortfolioProject..CovidDeath
Group by Location, Population
Order by HighestTotalDeathCount desc

Select Location, Population, Max(cast (total_deaths as int)) As HighestTotalDeathCount
From PortfolioProject..CovidDeath
Where Continent is not Null
Group by Location, Population
Order by HighestTotalDeathCount desc

--Breaking it down by Continent
--Showing the Continent with the highest Death Count

Select Continent, Max(cast (total_deaths as int)) As HighestTotalDeathCount
From PortfolioProject..CovidDeath
Where Continent is not Null
Group by Continent
Order by HighestTotalDeathCount desc

Select location, Max(cast (total_deaths as int)) As HighestTotalDeathCount
From PortfolioProject..CovidDeath
Where Continent is not Null
Group by Location
Order by HighestTotalDeathCount desc

--Global Numbers

Select date, Sum(new_cases) --as NewCasesCount
From PortfolioProject..CovidDeath
Where Continent is not Null
Group by date
Order by 1,2

Select date, Sum(new_cases), Sum(cast(new_deaths as int)) --as NewCasesCount
From PortfolioProject..CovidDeath
Where Continent is not Null
Group by date
Order by 1,2

Select date, Sum(new_cases) as TotalCases, Sum(cast(new_deaths as int)) as TotalDeaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathsPerNewCaesesPercentage
From PortfolioProject..CovidDeath
Where Continent is not Null
Group by date
Order by 1,2

Select Sum(new_cases) as TotalCases, Sum(cast(new_deaths as int)) as TotalDeaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathsPerNewCaesesPercentage
From PortfolioProject..CovidDeath
Where Continent is not Null
Order by 1,2

--Looking @ Total population vs Vaccination

Select *
from PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccination vac
ON dea.Location = vac.Location
	and dea.date = vac.date

	
Select dea.Continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccination vac
ON dea.Location = vac.Location
	and dea.date = vac.date
	Where dea.Continent is not Null
	Order by 1,2,3

Select dea.Continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccination vac
ON dea.Location = vac.Location
	and dea.date = vac.date
	Where dea.Continent is not Null
	Order by 2,3

Select dea.Continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Cast(vac.new_vaccinations as int)) Over (Partition by dea.Location Order by dea.Location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccination vac
ON dea.Location = vac.Location
	and dea.date = vac.date
	Where dea.Continent is not Null
	Order by 2,3

Select dea.Continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Convert(int, vac.new_vaccinations)) Over (Partition by dea.Location Order by dea.Location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccination vac
ON dea.Location = vac.Location
	and dea.date = vac.date
	Where dea.Continent is not Null
	Order by 2,3

	--Using CTE

WITH PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) as
(
Select dea.Continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Convert(int, vac.new_vaccinations)) Over (Partition by dea.Location Order by dea.Location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccination vac
ON dea.Location = vac.Location
	and dea.date = vac.date
	Where dea.Continent is not Null
	--Order by 2,3
) 
Select *, (RollingPeopleVaccinated/Population)*100 as PercentageRollingPeopleVaccinated
From PopvsVac

--Using Temp Table

Drop Table if exists #PercentagePopulationVaccinated 
	CREATE TABLE #PercentagePopulationVaccinated 
(
Continent nvarchar(255), 
location nvarchar(255), 
date datetime, 
population numeric, 
new_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

Insert into #PercentagePopulationVaccinated 
Select dea.Continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Convert(int, vac.new_vaccinations)) Over (Partition by dea.Location Order by dea.Location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccination vac
ON dea.Location = vac.Location
	and dea.date = vac.date
	Where dea.Continent is not Null

Select *, (RollingPeopleVaccinated/Population)*100 as PercentageRollingPeopleVaccinated
From #PercentagePopulationVaccinated 

--Creating View to Store Data for Later Visualization

Create View PercentagePopulationVaccinated as
Select dea.Continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Convert(int, vac.new_vaccinations)) Over (Partition by dea.Location Order by dea.Location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccination vac
ON dea.Location = vac.Location
	and dea.date = vac.date
	Where dea.Continent is not Null

	Select *
	From PercentagePopulationVaccinated