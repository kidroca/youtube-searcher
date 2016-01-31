# Youtube Searcher

## Main Purpose

The application gathers query information from the user and attempts to find videos related to
the query. Uses google’s youtube search api to fetch json data with meta information.

The found videos are displayed as thumbnails in a list. The thumbnails contain a thumb image, video title, and an info button. Clicking the button display a popup modal with available description for the video.
Clicking on the thumbnail (but not on the info button) opens the video.

### Functionality 

* Gathers information and builds a query object
* Creates and sends an http request and displays proggress
* Displays result as list:
	* Sortable by date, title, video length
* Displays additional info on button click
* Starts the selected video on click
* Stores search history in SQL-lite database
* Opitonal:
	* Shoot a video and uppload it to youtube