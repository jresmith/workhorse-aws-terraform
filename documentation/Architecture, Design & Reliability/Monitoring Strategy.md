# 🚧 Work in Progress

## Monitoring Strategy

* What to Monitor & why
* How alerts are structured
* How logs and Metrics connect
* Where we get logs
  - Application Logs
  - Load Balancer / Ingress Metrics
  - Syntetic Testing (vote-bot)
  - Client-Side (accessing UI myself)
* Dashboards I've built
  - Purpose
  - Key panels
  - Why these metrics matter
  - How to interpret anomolies 

## Expectations

* How can the app fail?
* What is an acceptable failure?
  - Malformed requetss faul
* Are all the users treated the same
* What is an error?
 - 400 or 500 from the app
 - 400 or 500 from ALB/Proxy/Ingress Controller

## Monitoring Ojectives

* List of Emojis can be viewed
  - Emojo Catalogue Avalibility
  - Emojo Catalogue Latency
* Votes can be cast
  - UI (web service) Availibility
  - UI (web service) Latency
  - Vote Cast (Voting Service) Availibility
  - Vote Cast (Voting Service) Latency
  - Vote Processing Success Rate
  - [End-to-end] Vote Processing time
* Leaderboard can be viewed