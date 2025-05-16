local function has_class(el, cls)
   if not el.classes then return false end
   for _, s in pairs(el.classes) do
      if s == cls then
         return true
      end
   end
   return false
end

local function is_output(el)
   return (el.t == "CodeBlock" and #el.classes == 0)
       or (el.t == "Para" and el.content[1].t == "Image")
end

local function begin_box()
   return pandoc.RawBlock('latex', '\\begin{chunk}')
end

local function divide_box()
   return pandoc.RawBlock('latex', '\\tcblower')
end

local function end_box()
   return pandoc.RawBlock('latex', '\\end{chunk}')
end

local function boxed(input_blocks)
   local blocks = {}
   local in_box = false

   for i, el in ipairs(input_blocks) do
      if is_output(el) then
         if in_box then
            table.insert(blocks, divide_box())
            table.insert(blocks, el)
            table.insert(blocks, end_box())
            in_box = false
         else
            table.insert(blocks, el)
         end
      elseif el.t == "CodeBlock" and has_class(el, 'r') then
         if in_box then
            table.insert(blocks, end_box())
         end
         table.insert(blocks, begin_box())
         table.insert(blocks, el)
         in_box = true
      else
         if in_box then
            table.insert(blocks, end_box())
         end
         table.insert(blocks, el)
         in_box = false
      end
   end

   return blocks
end

function Pandoc(doc)
   doc.blocks = boxed(doc.blocks)
   return doc
end

function OrderedList(list)
   for i, item in pairs(list.content) do
      list.content[i] = boxed(item)
   end
   return list
end
