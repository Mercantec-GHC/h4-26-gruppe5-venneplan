using API.DBContext;
using API.DTOS;
using API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EventController : ControllerBase
    {

        private readonly AppDBContext _context;


        public EventController(AppDBContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<EventGetDTO>>> GetAllUsers()
        {
            var events = await _context.Events
                .Select(e => new EventGetDTO
                {
                    Id = e.Id,
                    Title = e.Title,
                    Adress = e.Adress,
                    Date = e.Date,
                    Description = e.Description,
                    HostId = e.HostId,
                    Host = new GetUserDTO
                    {
                        Email = e.Host.Email,
                        Name = e.Host.Name,
                        City = e.Host.City,
                        Age = e.Host.Age
                    },
                    ParticipantCount = e.Participants.Count(p => p.IsGoing)
                })
                .ToListAsync();

            return Ok(events);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<EventGetDTO>> GetEventById(int id)
        {
            var evnt = await _context.Events
                .Where(e => e.Id == id)
                .Select(e => new EventGetDTO
                {
                    Id = e.Id,
                    Title = e.Title,
                    Adress = e.Adress,
                    Date = e.Date,
                    Description = e.Description,
                    HostId = e.HostId,
                    Host = new GetUserDTO
                    {
                        Email = e.Host.Email,
                        Name = e.Host.Name,
                        City = e.Host.City,
                        Age = e.Host.Age
                    },
                    ParticipantCount = e.Participants.Count(p => p.IsGoing)
                })
                .FirstOrDefaultAsync();
            if(evnt == null)
            {
                return NotFound();
            }
            return Ok(evnt);
        }

        [HttpGet("hostedBy/{hostId}")]
        public async Task<ActionResult<IEnumerable<EventGetDTO>>> GetByHost(int hostId)
        {
            var evnt = await _context.Events
                .Where(e => e.HostId == hostId)
                .Select(e => new EventGetDTO
                {
                    Id = e.Id,
                    Title = e.Title,
                    Adress = e.Adress,
                    Date = e.Date,
                    Description = e.Description,
                    HostId = e.HostId,          
                    Host = new GetUserDTO
                    {
                        Email = e.Host.Email,
                        Name = e.Host.Name,
                        City = e.Host.City,
                        Age = e.Host.Age
                    },
                    ParticipantCount = e.Participants.Count(p => p.IsGoing)
                })
                .ToListAsync();
            if(evnt == null)
            {
                return NotFound();
            }
            return Ok(evnt);
        }

        [HttpPost]
        public async Task<ActionResult<EventGetDTO>> CreateEvent([FromBody] EventCreateDTO createDto)
        {
            var host = await _context.Users.FindAsync(createDto.HostId);
            if(host == null)
            {
                return BadRequest("Host user not found.");
            }

            var newEvent = new Event
            {
                Title = createDto.Title,
                Adress = createDto.Adress,
                Date = DateTime.UtcNow,
                Description = createDto.Description,
                HostId = createDto.HostId,
                Host = host,
            };

            _context.Events.Add(newEvent);
            await _context.SaveChangesAsync();

            var eventDto = await _context.Events
                .Where(e => e.Id == newEvent.Id)
                .Select(e => new EventGetDTO
                {
                    Id = e.Id,
                    Title = e.Title,
                    Adress = e.Adress,
                    Date = e.Date,
                    Description = e.Description,
                    HostId = e.HostId,
                    Host = new GetUserDTO
                    {
                        Email = e.Host.Email,
                        Name = e.Host.Name,
                        City = e.Host.City,
                        Age = e.Host.Age
                    },
                    ParticipantCount = e.Participants.Count(p => p.IsGoing)
                })
                .FirstOrDefaultAsync();

            return CreatedAtAction(nameof(GetEventById), new { id = newEvent.Id }, eventDto);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteEvent(int id)
        {
            var evnt = await _context.Events.FindAsync(id);
            if(evnt == null)
            {
                return NotFound();
            }
            _context.Events.Remove(evnt);
            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<EventGetDTO>> UpdateEvent(int id, [FromBody] EventUpdateDTO updatedEvent)
        {
            var evnt = await _context.Events.FindAsync(id);
            if(evnt == null)
            {
                return NotFound();
            }
            
            evnt.Title = updatedEvent.Title;
            evnt.Adress = updatedEvent.Adress;
            evnt.Date = updatedEvent.Date;
            evnt.Description = updatedEvent.Description;
            evnt.HostId = updatedEvent.HostId;
            
            await _context.SaveChangesAsync();
            
            var eventDto = await _context.Events
                .Where(e => e.Id == id)
                .Select(e => new EventGetDTO
                {
                    Id = e.Id,
                    Title = e.Title,
                    Adress = e.Adress,
                    Date = e.Date,
                    Description = e.Description,
                    HostId = e.HostId,
                    Host = new GetUserDTO
                    {
                        Email = e.Host.Email,
                        Name = e.Host.Name,
                        City = e.Host.City,
                        Age = e.Host.Age
                    },
                    ParticipantCount = e.Participants.Count(p => p.IsGoing)
                })
                .FirstOrDefaultAsync();
            
            return Ok(eventDto);
        }
    }
}