-- Choose queries that demonstrate meaningful work rather than every query you ran.

-- SQL query1:
select * from branch_growth;

-- SQL query2 with aggregation:
select count(*) as total_branches, sum(Ad_Budget_K ) as total_ad_budget_k, sum(New_Accnts_Opened) AS total_new_accounts, AVG(New_Accnts_Opened) AS avg_accounts_per_branch from branch_growth;
