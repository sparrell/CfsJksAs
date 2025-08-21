defmodule Cfsjksas.Chart.Sector do
  @moduledoc """
  Sector is main Struct of this module

  Each "sector" is shape for a person.
    A generation has 2**gen sectors, numbered from the x-axis.
    A sector is identified by the generation and the sector number.
    A sector is a closed shape which consists of 4 joined paths:
    - inner arc
    - outer arc
    - lower ray
    - upper ray
    These are defined by 4 points.
      A-------------------B
        *                *
         *              *
          *            *
           C----------D

    Point A:
      - 'higher' end on 'outer arc'
      - 'outside' end of 'higher' ray
      - radians = (sector number + 1 mod gen**2) * 2pi / 2**gen
      - A and C have same radians
    Point B:
      - 'lower' end on 'outer arc'
      - 'outside' end of 'lower' ray
      - radians = (sector number) * 2pi / 2**gen
      - B and D have same radians
    Point C:
      - 'higher' end on 'inner arc'
      - 'inside' end of 'higher' ray
      - radians = (sector number + 1 mod gen**2) * 2pi / 2**gen
      - A and C have same radians
    Point D:
      - 'lower' end on 'inner arc'
      - 'inside' end of 'lower' ray
      - radians = (sector number) * 2pi / 2**gen
      - B and D have same radians
    Arc AB is the outer_arc
    Arc CD is the inner_arc
    Ray CA is the higher_ray
    Ray DB is the lower_ray

  make(generation, quadrant, sector_number)
     creates and populates the struct

  """
  require IEx

  defstruct [
    id: "need",
    gen: 0,
    sector_num: 0,
    line_color: "black",
    stroke_width: "50",
    fill: "none",
    fill_opacity: "50%",
    quadrant: :ne,
    reverse: false,
    inner_radius: 100,
    outer_radius: 200,
    lower_radians: 0,
    upper_radians: :math.pi(),
    a_x: 0,
    a_y: 0,
    b_x: 0,
    b_y: 0,
    c_x: 0,
    c_y: 0,
    d_x: 0,
    d_y: 0,
    svg: "",
    namelines: %{}
  ]

  @type t() :: %__MODULE__{
    id: String.t(),
    gen: integer(),
    sector_num: integer(),
    line_color: String.t(),
    stroke_width: String.t(),
    fill: String.t(),
    fill_opacity: String.t(),
    quadrant: atom(),
    reverse: boolean(),
    inner_radius: integer(),
    outer_radius: integer(),
    lower_radians: integer(),
    upper_radians: float(),
    a_x: integer(),
    a_y: integer(),
    b_x: integer(),
    b_y: integer(),
    c_x: integer(),
    c_y: integer(),
    d_x: integer(),
    d_y: integer(),
    svg: String.t(),
    namelines: map()
  }

  def make(generation, quadrant, sector_number) do
    # get config for this sector
    cfg = Cfsjksas.Chart.Get.config().sector[generation]
{quadrant, sector_number,cfg}
  end




end
