## I Should probably use something like Redis for this...
class Queue
  @@list = []
  @@last_id = 0

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
    @@list.push({id: @@last_id, xp_id: xp_id})
    @@last_id++
    return @@last_id - 1
  end

  def self.remove_from_queue(item_id)
    index = @@list.rindex{|item| item[:id] == item_id}
    return nil if index.nil?
    @@list.delete(@@list[index])
  end

  def self.get_queue_item(item_id)
    index = @@list.rindex{|item| item[:id] == item_id}
    return nil if idex.nil?
    item = @@list[index]
    item[:last_check] = Time.now
    item[:estimated_time] = self.get_estimated_time(item_id)
  end

  def self.check_inactive_items()
    now = Time.now
    @@list.each do |item|
      @@list.delete(item) if now - item[:last_check] > 30.0
    end
  end
end