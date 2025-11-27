# Yelpventure
An RPG-based web-game that's based on the 2025 Yelp AI Hackathon that makes people want to explore things (can even fit VR/AR if needed)

## Inspirations
When I did AP English Literature back in high school, I made an interactive version of the _Frankenstein_ story as a 3D game (although only one scene I programmed since at that time, it would've taken a whole ordeal of effort to having complete the entire novel). However, with that game, I wanted users to be able to change the story of the game and impact the way the story progresses. Now that I'm in college and learned quite a bit of nice web technologies I can harvest with some of that Unity knowledge I had back then (and even now from a few semesters ago while doing VR/AR research), I wanted to see if I can make this Yelp AI hackathon fun :D

With the help of Yelp's AI API, I've read you can get cool locations by talking to the API in a conversational way. What better way to leverage that with a game? In this RPG game, the app gives you daily/weekly "quests" based off Yelp's AI API that will recommend locations based off a particular challenge. Here's a few examples: 
1. "Defeat the Spice Lord" -> try out three restaurants that have a particularly high scoville (the rating of spice) score
2. "A coffee connoisseur" -> visit 5 different coffee shops
3. "Explorer" -> go into an exotic restaurant with very unique food options

(of course, these challenges above are not static and can be dynamically made by an AI agent that will "act" as the game master in which gives you different challenges each day) 

Each time you complete these challenges, you earn XP, level up, unlock badges, and get a chance to be on leaderboards! How fun is that??

In addition, I also wanted to make this feel 3D-esque with the option of having AR elements within the web so that users feel more immersed into this.

## Architecture Diagram
<img width="1743" height="482" alt="image" src="https://github.com/user-attachments/assets/65687495-6f4d-426d-a474-4e5d45cdeb94" />

^ this is the high-level idea I had in mind for making my Yelpventure game ^
