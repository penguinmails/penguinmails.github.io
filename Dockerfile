# Jekyll documentation setup with Just the Docs theme
FROM jekyll/jekyll:latest

# Install required plugins for Just the Docs
RUN gem install webrick jekyll-remote-theme jekyll-include-cache

# Set working directory and copy files
WORKDIR /srv/jekyll
COPY . .

# Expose Jekyll development port
EXPOSE 4000

# Start Jekyll development server
CMD ["jekyll", "serve", "--host", "0.0.0.0", "--watch", "--force_polling"]