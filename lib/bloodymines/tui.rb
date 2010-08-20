require "curses"
include Curses

module Curses
  def self.program
    main_screen = init_screen   # init curses
    noecho                      # don't show what you type
    trap(0) { echo }            # reactivate echo on exit
    cbreak                      # turn off buffered input
    curs_set(0)                 # hide cursor
    main_screen.keypad = true   # cursor keys are real events
    yield main_screen
  end
end

module TUI
  SPACING, X_OFFSET, Y_OFFSET = 1, 1, 1
  attr_accessor :cursor_x, :cursor_y

  def draw_field
    @cursor_x = @cursor_x || 0
    @cursor_y = @cursor_y || 0
    clear
    0.upto(@width - 1) do |x|
      0.upto(@height - 1) do |y|
        # curses swaps x and y
        setpos(y + Y_OFFSET, x + X_OFFSET + spacing(x, SPACING))
        field = case @minefield.fields[x][y]
                when false, :mine: "."
                when :boom: "X"
                else @minefield.fields[x][y].to_s
                end
        addstr(field)
      end
    end
    draw_cursor
    setpos(0, 1)
    addstr("Score: #{result[:score]}")
    setpos(@height + 2, 1)
    addstr("Use the arrow keys to move around.\n Hit Space to reveal a field. Q or ESC quits the game.")
    refresh
  end

  def spacing(x, space)
    x * space
  end

  def draw_cursor
    x = @cursor_x + X_OFFSET + spacing(@cursor_x, SPACING)
    y = @cursor_y + Y_OFFSET
    setpos(y, x - 1)
    addstr("[")
    setpos(y, x + 1)
    addstr("]")
  end

  def move(params={})
    case params[:direction]
    when :up
      @cursor_y -= 1 if @cursor_y > 0
    when :down
      @cursor_y += 1 if @cursor_y < @height - 1
    when :left
      @cursor_x -= 1 if @cursor_x > 0
    when :right
      @cursor_x += 1 if @cursor_x < @width - 1
    end
  end

  def turn
    draw_field
    case getch
    when Key::UP : move(:direction => :up)
    when Key::DOWN : move(:direction => :down)
    when Key::LEFT : move(:direction => :left)
    when Key::RIGHT : move(:direction => :right)
    when 32 : uncover(@cursor_x, @cursor_y)
    when 27, ?q, ?Q : break
    end
    
  end
end
