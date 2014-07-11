class Queue
  @@list = []

  def self.get_estimated_time(item_id=@@list.length-1)
    estimated_time = 0
    @@list.each_index do |index|
      estimated_time += Xp[@@list[index].xp_id].estimated_time
      break if item_id == index
    end
    return estimated_time
  end

  def self.get_state
    state = {queue_length: @@list.length}
    state[:estimated_time] = self.get_estimated_time()
  end

  def self.add_to_queue(xp_id)
    @@list.push({xp_id: xp_id})
    return @@list.length - 1
  end

  def self.remove_from_queue(item_id)
    @@list.delete(@@list[item_id])
  end

  def self.get_queue_item(item_id)
    item = @@list[item_id]
    return item if item.nil?
    item[:estimated_time] = self.get_estimated_time(item_id)
  end
end