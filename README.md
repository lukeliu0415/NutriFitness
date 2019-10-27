# NutriFitness

NutriFitness is an app designed to make managing your diet and exercise easy. NutriFitness allows users to take pictures of their food, and add the nutrition info straight into HealthKit. The app has two main views, the Exercise view and the Nutrition view.

## Exercise View
The Exercise view has the purpose to showcase simply, how much time the user would have to put in to break net zero on their caloric intake. This view makes it simple to see what you have to do, and how much of it you have to do. The Exercise view takes into account the metabollic rate of the person, how many calories they have eaten in the day and from there determines how much exercise it will take to burn the extra calories.

## Nutrition View
The Nutrition view gives the user a breakdown of nutrients and how much of that nutrient they have eaten, in percentage. This daily value is determined through the app's onboarding, which calculates Base Metabollic Rate and Daily Intake based on the paramaters provided to the user.


## Food Recognition
Food recognition allows for users to simply take a picture of a food item, we use CoreML to see what object it is, and then get the nutrition info for that food item, and simply write it straight into HealthKit.
