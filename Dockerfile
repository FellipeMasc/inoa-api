
FROM ruby:3.1.1

WORKDIR /app

COPY . .

RUN apt-get update && apt-get install -y bash

EXPOSE 3000

CMD ["bash", "-c", "bundle install && rails db:create && rails db:migrate && rails server -b 0.0.0.0"]
