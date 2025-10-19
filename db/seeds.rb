# Sample blog posts for development
Post.create!([
  {
    title: "Welcome to Our Blog",
    content: "This is our first blog post! We're excited to share our thoughts and experiences with you. Rails makes it incredibly easy to build powerful web applications, and we're here to document our journey. Stay tuned for more exciting content about web development, Ruby on Rails, and software engineering best practices.",
    author: "Admin",
    published_at: 2.days.ago
  },
  {
    title: "Getting Started with Rails 8",
    content: "Rails 8 brings many exciting features to the framework. From improved performance with the new asset pipeline to better deployment tools like Kamal, there's a lot to explore. In this post, we'll dive into some of the key features that make Rails 8 a game-changer for web development. The Solid stack provides database-backed solutions for caching, job processing, and real-time features.",
    author: "Rails Developer",
    published_at: 1.day.ago
  },
  {
    title: "Building Modern Web Applications",
    content: "Modern web applications require a balance of performance, maintainability, and user experience. With tools like Hotwire Turbo and Stimulus, Rails applications can feel as responsive as single-page applications while maintaining the simplicity of traditional server-rendered apps. Let's explore how to build fast, interactive web applications with Rails.",
    author: "Frontend Specialist",
    published_at: Time.current
  },
  {
    title: "Draft: Upcoming Features",
    content: "This is a draft post about upcoming features we're working on. It includes exciting new functionality that we can't wait to share with our users. This post is not yet published and serves as an example of draft functionality.",
    author: "Product Manager",
    published_at: nil  # This is a draft (not published)
  }
])
