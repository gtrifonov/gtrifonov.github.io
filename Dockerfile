# Use an official Ruby runtime as a parent image
FROM ruby:2.7

# Set the working directory in the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock from your project into the container
COPY Gemfile ./

# Install Jekyll and other dependencies
RUN bundle install

# Copy the rest of your Jekyll project into the container
COPY . .

# Expose the default Jekyll port
EXPOSE 4000

# Start the Jekyll server
CMD ["bundle", "exec", "jekyll", "serve"], "--host", "0.0.0.0"]
