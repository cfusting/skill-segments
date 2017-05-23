# Skill Set Discovery
With the emergence of the [gig economy](http://www.economist.com/news/finance-and-economics/21693261-new-report-reveals-scale-and-purpose-app-based-earnings-smooth-operators) and the rapid development of technology employers are increasingly looking for unique and sometime rare sets of skills. In this work I developed methods for a previous client, [Aquent](https://aquent.com/), to find emergent skill sets and use them to understand current market trends.

*Note: All code related to pulling data has been removed to protect Aquent's privacy.*

## Goals
Aquent is a temporary staffing company that finds people contractual work in creative roles such as Graphic Design, Copyediting, Illustrating, etc. Aquent acts as a freelancer's agent, connecting qualified people with meaningful work. Many people spend large portions of their careers with Aquent as they enjoy the variety of projects and companies that comes with freelancing without having to worry about finding the work themselves. 

Aquent makes money off every order (contractual position) they staff and thus has a vested interest in staffing as many orders as the sales team has found. Finding the right talent (temporary worker) for an order can be tricky and depends on the client's location, culture, experience, and other qualifications. 

At the core of a talent's qualifications is her skill set. Aquent realized this and created a free online training program called [Gymnasium](https://thegymnasium.com/) to help talent (or anyone) build their skills sets for free. Identifying emerging skill sets is thus a goal of Aquent as it allows them to tailor courses today relevant to tomorrow's orders. Thus there are two primary goals:

1. Discover what skill sets that are emerging in new orders.
2. Determine if the talent base has these skill sets and if not ramp up recruiting and training efforts in these areas.

## Solution
When Aquent tries to fill an order various talent become associated with it and reach different levels of candidacy. If a talent is interviewed by the client that placed the order, it is very likely they have the core skill set necessary for the job. The skills of each talent (derived from their profile) who interviewed for an order are grouped together and the clustering algorithm [Latent Dirichlet Allocation](https://en.wikipedia.org/wiki/Latent_Dirichlet_allocation) (LDA) is used to discover latent sets of skills.

![Clustering Skills](https://github.com/cfusting/cfusting.github.io/blob/master/img/portfolio/skillsegments-free.jpg)

The skill clusters provide a clear view of what skills occur together on orders. The following are two examples of actual skill sets found in this work:

|skill set 1|skill set 2|
|:-------------:|:-------------:|
|html           |graphic_design |
|css            |illustrator    |
|javascript     |adobe_creative_suite|
|php            |indesign       |
|web_design     |photoshop      |
|...            |...            |

Cleary skill set 1 is a web designer and skill set 2 is a more traditional graphic designer. 

## Action
Using the skill sets discovered it is now possible to:

1. Discover emerging skill sets in new orders.
2. Quantify exactly how often these skill sets are in demand.
3. Determine how much of the talent base has these skill sets.
4. Ramp up recruiting and training efforts as necessary.


