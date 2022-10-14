local home = os.getenv "HOME"
local nvim_path = home .. "/.config/nvim/"
local custom_path = nvim_path .. "lua/custom/"
local example_path = nvim_path .. "example/"

local is_docker = os.getenv "DOCKER_RUN"
local custom_branch = os.getenv "CUSTOM_BRANCH"
local custom_repo = os.getenv "CUSTOM_REPO"

local different_branch = function()
  if custom_branch ~= nil then
    return true
  end
  return false
end

local different_repo = function()
  if custom_repo ~= nil then
    return true
  end
  return false
end

local different_repo_and_branch = function()
  if different_repo() and different_branch() then
    return true
  end
  return false
end

local directory_contents = {
  "mappings.lua",
  "init.lua",
  "sigmarc.lua",
  "plugins/",
}

local function create_directory(path)
  os.execute("mkdir -p " .. path)
end

local function copy_example_files()
  create_directory(custom_path)
  for file_num in pairs(directory_contents) do
    local okay = os.rename(example_path .. directory_contents[file_num], custom_path .. directory_contents[file_num])
    if okay then
      print(
        "COPYING: "
          .. example_path
          .. directory_contents[file_num]
          .. " -> "
          .. custom_path
          .. directory_contents[file_num]
      )
    end
  end
end

local function clone_repo(url, path_to_clone)
  print("CLONING: " .. url)
  return os.execute("git clone " .. url .. " " .. path_to_clone)
end

local function default_clone()
  return os.execute("git clone https://github.com/SigmaNvim/SigmaNvim.git " .. nvim_path .. " --depth 1")
end

local function different_branch_clone(branch)
  return os.execute(
    "git clone --branch " .. branch .. " https://github.com/SigmaNvim/SigmaNvim.git " .. nvim_path .. " --depth 1"
  )
end

-- --
-- --

local function interactive_setup()
  local answer
  repeat
    io.write "Would you like to initilize with default configuration or supply a git repo url to a previous configuration?\n('y' for default / 'n' for custom git): "
    io.flush()
    answer = io.read()
  until string.lower(answer) == "y" or string.lower(answer) == "n"
  local repo
  if answer == "n" then
    io.write "Enter the git repos url: "
    repo = io.read()
    io.flush()
  end
  answer = string.lower(answer)
  print "\nCloning SigmaNvim..."
  local cloned = default_clone()
  if cloned then
    if answer == "y" then
      create_directory(custom_path)
      copy_example_files()
    end
    if answer == "n" then
      print("\nCloning " .. repo)
      local ok = clone_repo(repo, custom_path)
      if ok then
        print "Cloned custom repo succesfully"
      end
    end
  end
end

local function docker_setup()
  if different_branch() and not different_repo() then
    local cloned = different_branch_clone(custom_branch)
    if cloned then
      print "Cloned succesfully"
      copy_example_files()
      return true
    end
    return false
  end
  if not different_branch() and different_repo() then
    local cloned = default_clone()
    local custom_repo_clone = clone_repo(custom_repo, custom_path)
    if cloned and custom_repo_clone then
      print "Cloned succesfully"
      return true
    end
    return false
  end
  if different_repo_and_branch() then
    local cloned_repo = different_branch_clone(custom_branch)
    local clone_custom = clone_repo(custom_repo, custom_path)
    if cloned_repo and clone_custom then
      print "Cloned succesfully"
      return true
    end
    return false
  end
  if not different_repo_and_branch() then
    local cloned = default_clone()
    if cloned then
      print "Cloned succesfully."
      copy_example_files()
      return true
    end
    return false
  end
end

if is_docker ~= nil then
  docker_setup()
end

if is_docker == nil then
  interactive_setup()
end

os.execute "nvim"
