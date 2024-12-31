# frozen_string_literal: true

input = $stdin.read.strip.chars
pos = 0 + 0.i

def step(pos, dir)
  case dir
  when '^'
    pos - 1.i
  when 'v'
    pos + 1.i
  when '<'
    pos - 1
  when '>'
    pos + 1
  end
end

santa_path = input.each_with_object([pos]) do |step, path|
  curr_pos = path[-1]
  next_pos = step(curr_pos, step)
  path << next_pos
end
p santa_path.to_set.size
part2 = input.each_slice(2).each_with_object([[0 + 0.i], [0 + 0.i]]) do |steps, paths|
  santa_path, robot_path = paths
  santa_step, robot_step = steps
  santa_path << step(santa_path[-1], santa_step)
  robot_path << step(robot_path[-1], robot_step)
  [santa_path, robot_path]
end
p part2.flatten.to_set.size
