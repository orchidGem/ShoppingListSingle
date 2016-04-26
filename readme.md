Grocery Pal is an iOS mobile app that allows users the ability create a grocery shopping list and to view recipes from the Food2Fork.com website.

## Features

- [x] Manage, add/delete, Grocery Shopping List Items
- [x] Share Grocery List
- [x] View recipes using Food2Fork API
- [x] Save recipes as favorites
- [x] Add recipe ingredients to shopping list
- [x] Incorporates the AlamoFire Library for url request and image downloads

## Shopping List Feature Details

Users have the ability to add items to their grocey list which is persisted in Core Data. Users can add and delete items from the list. Users can share the list using the UIActivityViewController.

## Recipe Feature Details
Users are shown the 30 most recent recipes from the Food2Fork API. The next 30 recipes are loaded into the list if the user has scrolled to the last cell in the table view. The list is divided into an ALL section and a FAVORITES section.  User can select a recipe to view the recipe detail page which contains the ingredients, the link to view the recipe online, a favorite button that adds the recipe to the favorites, and an add ingredients button that adds the ingredients to their shopping list. 