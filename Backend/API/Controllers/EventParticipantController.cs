using API.DBContext;
using API.DTOS;
using API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EventParticipantController : ControllerBase
    {
        private readonly AppDBContext _context;


        public EventParticipantController(AppDBContext context)
        {
            _context = context;
        }

        [HttpPost("participants")]
        public async Task<IActionResult> AddParticipant([FromBody] AddParticipantDTO dto)
        {
            var evnt = await _context.Events.FindAsync(dto.EventId);
            if(evnt == null)
            {
                return NotFound("Event not found.");
            }

            var user = await _context.Users.FindAsync(dto.UserId);
            if(user == null)
            {
                return NotFound("User not found.");
            }

            var existingParticipant = await _context.EventParticipants
                .FirstOrDefaultAsync(ep => ep.EventId == dto.EventId && ep.UserId == dto.UserId);

            if(existingParticipant != null)
            {
                return Conflict("User is already registered for this event.");
            }

            var participant = new EventParticipant
            {
                EventId = dto.EventId,
                Event = evnt,
                UserId = dto.UserId,
                User = user,
                IsGoing = dto.IsGoing
            };

            _context.EventParticipants.Add(participant);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Participant added successfully", participantId = participant.Id });
        }

        [HttpGet("participants")]
        public async Task<ActionResult<IEnumerable<GetParticipantDTO>>> GetParticipants()
        {
            var participants = await _context.EventParticipants
                .Select(ep => new GetParticipantDTO
                {
                    Id = ep.Id,
                    EventId = ep.EventId,
                    UserId = ep.UserId,
                    IsGoing = ep.IsGoing
                })
                .ToListAsync();
            return Ok(participants);
        }

        [HttpGet("participants/{eventId}")]
        public async Task<ActionResult<IEnumerable<GetParticipantDTO>>> GetParticipantsByEvent(int eventId)
        {
            var participants = await _context.EventParticipants
                .Where(ep => ep.EventId == eventId)
                .Select(ep => new GetParticipantDTO
                {
                    Id = ep.Id,
                    EventId = ep.EventId,
                    UserId = ep.UserId,
                    IsGoing = ep.IsGoing
                })
                .ToListAsync();
            return Ok(participants);
        }

        [HttpGet("participants/user/{userId}")]
        public async Task<ActionResult<IEnumerable<GetParticipantDTO>>> GetEventsByUser(int userId)
        {
            var events = await _context.EventParticipants
                .Where(ep => ep.UserId == userId)
                .Select(ep => new GetParticipantDTO
                {
                    Id = ep.Id,
                    EventId = ep.EventId,
                    UserId = ep.UserId,
                    IsGoing = ep.IsGoing
                })
                .ToListAsync();
            return Ok(events);
        }

        [HttpDelete("participants/{id}")]
        public async Task<IActionResult> RemoveParticipant(int id)
        {
            var participant = await _context.EventParticipants.FindAsync(id);
            if(participant == null)
            {
                return NotFound("Participant not found.");
            }
            _context.EventParticipants.Remove(participant);
            await _context.SaveChangesAsync();
            return Ok(new { message = "Participant removed successfully" });
        }

        [HttpPut("participants/{id}")]
        public async Task<IActionResult> UpdateParticipantStatus(
            int id,
            [FromBody] UpdateParticipantStatusDTO dto
        )
        {
            var participant = await _context.EventParticipants.FindAsync(id);
            if(participant == null)
            {
                return NotFound("Participant not found.");
            }
            participant.IsGoing = dto.IsGoing;
            await _context.SaveChangesAsync();
            return Ok(new { message = "Participant status updated successfully" });
        }
    }
}
