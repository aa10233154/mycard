#encoding: UTF-8
class Widget_Msgbox < Window
  def initialize(title, message, buttons={:ok => "确定"}, &proc)
    #@background = Surface.load 'graphics/system/msgbox.png'
    @contents = Surface.load 'graphics/system/msgbox.png'
    @button = Surface.load 'graphics/system/button.png'
    @font = TTF.open("fonts/WenQuanYi Micro Hei.ttf", 16)
    super((1024-@contents.w)/2, 230, @contents.w, @contents.h)
    @title = title
    @message = message
    @buttons = buttons
    @proc = proc
    
    @index = nil
    
    @items = {}
    @space = (@width - @buttons.size * @button.w / 3) / (@buttons.size + 1)
    button_y = 100
    
    @buttons.each_with_index do |button, index|
      @items[button[0]] = [(@space+@button.w)*index+@space, button_y, @button.w/3, @button.h]
    end
    refresh
  end
  def title=(title)
    @title.replace title
    refresh
  end
  def message=(message)
    @message.replace message
    refresh
  end
  def buttons=(buttons)
    @buttons.replace buttons
    refresh
  end
  def refresh
    @contents = Surface.load 'graphics/system/msgbox.png'
    @font.draw_blended_utf8(@contents, @title, (@width-@font.text_size(@title)[0])/2, 2, 0xFF, 0xFF, 0xFF)
    @font.draw_blended_utf8(@contents, @message, 2, 24+2, 0xFF, 0xFF, 0x66)
    @items.each_key do |index|
      draw_item(index, @index == index ? 1 : 0)
    end
  end
  def draw_item(index, status=0)
    Surface.blit(@button,@button.w/3*status,0,@button.w/3,@button.h,@contents,@items[index][0],@items[index][1])
    text_size = @font.text_size(@buttons[index])
    @font.draw_blended_utf8(@contents, @buttons[index], @items[index][0]+(@button.w/3-text_size[0])/2, @items[index][1]+(@button.h-text_size[1])/2, 0xFF, 0xFF, 0xFF)
  end
  def mousemoved(x,y)
    self.index = @items.each do |index, item_rect|
      if x.between?(@x+item_rect[0], @x+item_rect[0]+item_rect[2]) and y.between?(@y+item_rect[1], @y+item_rect[1]+item_rect[3])
        break index
      end
    end
  end
  def index=(index)
    return if index == @index
    
    if @index
      #clear(*item_rect(@index))
      draw_item(@index, 0) 
    end
    if index.nil? or !@items.include? index
      @index = nil
    else
      @index = index
      draw_item(@index, 1)
    end
  end
  def clicked
    @proc.call(@index) if @index
    self.destroy
  end
end