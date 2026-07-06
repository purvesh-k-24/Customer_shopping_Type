import pandas as pd

df = pd.read_csv("customer_shopping_behavior.csv")

print(df)

df.info()

df.describe(include='all')

df.isnull().sum()

df['Review Rating'] = df.groupby('Customer ID')['Review Rating'].transform(lambda x: x.fillna(x.median()))
df.isnull().sum()

df.columns = df.columns.str.lower()
df.columns = df.columns.str.replace(' ', '_')
df = df.rename(columns={'purchase_amount_(usd)': 'purchase_amount'})

# create a column age_group
labels = ['Young Adult', 'Adult', 'Middle Aged', 'Senior']
df['age_group'] = pd.cut(df['age'], bins=4 , labels = labels)

# create column purchase_frequency_days

frequency_mapping = {
'Fortnigtly': 14,
'Weekly': 7,
'Quarterly': 90,
'Monthly': 30,
'Bi-Weekly': 14,
'Annually': 365,
'Every 3 Months': 90
}
df['purchase_frequency_days'] = df['frequency_of_purchases'].map(frequency_mapping)

print(df[['frequency_of_purchases', 'purchase_frequency_days']].head(10))

print(df[['discount_applied', 'purchase_amount']].head(10))

(df['discount_applied'] == df['promo_code_used']).all()

df = df.drop('promo_code_used', axis=1)

print(df.head())
