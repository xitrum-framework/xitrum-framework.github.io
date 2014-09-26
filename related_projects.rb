# Update gh-pages for related projects.
# Assume that directory of these project are at the same level with
# the directory of xitrum-hp.
related = ['glokka', 'sclasner', 'xitrum-scalate']

# The current branch should be "gh-pages"
def copy_gh_pages(project)
  `mkdir #{project}`
  `cd ../#{project}; git clean -fd; cp -r * ../xitrum-hp/#{project}/`
end

def update(project)
  puts "Update gh-pages for #{project}"

  unless File.exist?("../#{project}")
    puts "Checkout project #{project}..."
    `cd ..; git clone https://github.com/xitrum-framework/#{project}.git`
  end

  status = `cd ../#{project}; git status`
  if status.include?('On branch gh-pages')
    copy_gh_pages(project)
    return
  end

  clean = status.include?('nothing to commit, working directory clean')
  unless clean
    puts "Do nothing because directory #{project} is not clean"
    return
  end

  branches     = `cd ../#{project}; git branch -a`
  has_gh_pages = branches.include?('gh-pages')
  unless has_gh_pages
    puts "Project #{project} does not have branch gh-pages"
    return
  end

  `cd ../#{project}; git checkout gh-pages`
  puts `cd ../#{project}; git status`
  copy_gh_pages(project)
end

related.each { |project| update(project) }
