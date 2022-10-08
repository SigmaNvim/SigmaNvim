local home = os.getenv "HOME"
local custom_path = home .. "/.config/nvim/lua/custom/"
local example_path = home .. "/.config/nvim/example/"

local function tablelength(T)
  local count = 0
  for _ in pairs(T) do
    count = count + 1
  end
  return count
end

local arg_len = tablelength(arg)
local different_branch = arg_len == 3
local different_repo_and_branch = arg_len == 4
local is_docker = os.getenv "DOCKER_RUN"
local custom_branch = arg[1]
local custom_repo = arg[2]

local directory_contents = {
  "mappings.lua",
  "init.lua",
  "sigmarc.lua",
  "plugins/",
}

local function copy_example_files()
  for file_num in pairs(directory_contents) do
    os.rename(example_path .. directory_contents[file_num], custom_path .. directory_contents[file_num])
  end
end

local function create_directory(path)
  os.execute("mkdir -p " .. path)
end
local function clone_repo(url, path_to_clone)
  return os.execute("git clone " .. url .. " " .. path_to_clone)
end
local function default_clone()
  return os.execute "git clone https://github.com/SigmaNvim/SigmaNvim.git ~/.config/nvim --depth 1"
end

-- --
-- --

if is_docker == nil then
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

if is_docker ~= nil then
  if different_branch then
    local cloned = os.execute(
      "git clone --branch " .. custom_branch .. " https://github.com/SigmaNvim/SigmaNvim.git ~/.config/nvim --depth 1"
    )
    copy_example_files()
    if cloned then
      print "Cloned succesfully"
    end
  end
  if different_repo_and_branch then
    local cloned =
      os.execute("git clone --branch " .. custom_branch .. " " .. custom_repo .. " ~/.config/nvim --depth 1")
    if cloned then
      print "Cloned succesfully"
      copy_example_files()
    end
  end
  if not different_branch and not different_repo_and_branch then
    local cloned = default_clone()
    if cloned then
      print "Cloned succesfully."
      os.execute "nvim"
    end
  end
end
