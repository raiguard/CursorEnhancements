local base_mapping = {}

-- ! TEMPORARY

base_mapping = {
  belts = {
    {
      order = 100,
      {item="transport-belt", order=15},
      {item="fast-transport-belt", order=30},
      {item="express-transport-belt", order=45},
    },
    {
      order = 200,
      {item="underground-belt", order=15},
      {item="fast-underground-belt", order=30},
      {item="express-underground-belt", order=45},
    },
    {
      order = 300,
      {item="splitter", order=15},
      {item="fast-splitter", order=30},
      {item="express-splitter", order=45},
    }
  }
}

return base_mapping