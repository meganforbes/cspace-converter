# add promote method to array class
# https://stackoverflow.com/questions/12714186/reposition-an-element-to-the-front-of-an-array-in-ruby
class Array
  def promote(promoted_element)
    return self unless (found_index = find_index(promoted_element))

    unshift(delete_at(found_index))
  end
end
