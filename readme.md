# Skill-Segment Discovery
With the emergence of the [gig economy](http://www.economist.com/news/finance-and-economics/21693261-new-report-reveals-scale-and-purpose-app-based-earnings-smooth-operators) and the rapid development of technology employers are increasingly looking for unique and sometime rare sets of skills. In this work I develop methods to find emergent skill sets (henceforth called skill-segments) and use them to understand current market trends. This repository contains the R code I developed for a previous client [Aquent](https://aquent.com/).

## Business Goals
Aquent is a temporary staffing company that finds people contractual work in creative roles such as Graphic Design, Copyediting, Illustrating, etc. Aquent acts as a freelancers agent, connecting qualified people with meaningful, contractual work. Many people spend large portions of their careers with Aquent as they enjoy the variety of projects and companies. 
Aquent makes money off every order (contractual position) they staff and thus has a vested interest in staffing as many orders as the sales team has found. Finding the right talent (temporary worker) for an order can be tricky and depends on location, culture, experience, and other qualifications. 
At the core of a talent's qualifications is her skill-set. Aquent realized this and created a free online training program called [Gymnasium](https://thegymnasium.com/) to help talent (or anyone) build their skills sets. Identifying emerging skill-segments is thus a goal of Aquent as it allows them to tailor courses today relevant to tomorrow's orders.

## Solution
When Aquent tries to fill an order talent become associated with it and reach different levels of candidacy. If a talent is interviewed by the client that placed the order, it is very likely they have the core skill-set necessary for the job. The skills of each talent (derived from their profile) who interviewed for an order are grouped together and the clustering algorithm [Latent Dirichlet Allocation](https://en.wikipedia.org/wiki/Latent_Dirichlet_allocation) (LDA) is used to discover latent skill-segments.

![Clustering Skills](https://github.com/cfusting/cfusting.github.io/blob/master/img/portfolio/skillsegments-free.jpg)

The skill-segments provide a clear view of what skills occur together on orders. The following are two examples:

|skill-segment 1|skill-segment 2|
|:-------------:|:-------------:|
|html           |graphic_design |
|css            |illustrator    |
|javascript     |adobe_creative_suite|
|php            |indesign       |
|web_design     |photoshop      |
|...            |...            |

Cleary skill-segment1 is a web designer and skill-segment 2 is a more traditional graphic designer. These skill-segments give us a clear picture of the core skill-sets desired by clients.

Skill-segments have a variety of uses including
* Finding emergent core skill-sets.
* Determining how many talent in Aquent's database have core-skill sets.
* Assessing trends in the demand for core-skill sets.

This information gives Aquent the tools to make data-driven training and recruiting decisions.
