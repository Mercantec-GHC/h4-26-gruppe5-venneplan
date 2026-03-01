using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using API.DBContext;
using API.Models;
using API.DTOS;
using Microsoft.EntityFrameworkCore;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FriendsController : Controller
    {
        private readonly AppDBContext _context;

        public FriendsController(AppDBContext context)
        {
            _context = context;
        }

        [HttpGet("user/{userId}")]
        public async Task<ActionResult<IEnumerable<FriendDTO>>> GetFriends([FromRoute] int userId)
        {
            var friends = await _context.Friends
                .Where(f => f.UserId == userId)
                .ToListAsync();

            return Ok(friends);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<FriendDTO>> GetFriend([FromRoute] int id)
        {
            var friend = await _context.Friends.FindAsync(id);
            if (friend == null)
            {
                return NotFound();
            }

            return Ok(friend);
        }

        [HttpPost("addFriend")]
        public async Task<IActionResult> SendFriendRequest([FromBody] AddFriendDTO dto)
        {
            // Ensure both users exist to satisfy foreign key constraints
            var user = await _context.Users.FindAsync(dto.UserId);
            if (user == null)
            {
                return NotFound($"User with id {dto.UserId} does not exist.");
            }

            var friendUser = await _context.Users.FindAsync(dto.FriendId);
            if (friendUser == null)
            {
                return NotFound($"Friend with id {dto.FriendId} does not exist.");
            }

            var friend = new Friend
            {
                UserId = dto.UserId,
                FriendId = dto.FriendId,
                FriendScore = dto.FriendScore,
                FriendRequestStatus = dto.FriendRequestStatus
            };
            _context.Friends.Add(friend);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException ex)
            {
                // Return a 400 with a short message instead of allowing the exception to bubble up
                return BadRequest(new { message = "Could not add friend. Database update error.", detail = ex.Message });
            }

            return Ok(friend);
        }

        [HttpPut("acceptFriend/{id}")]
        public async Task<ActionResult<AcceptFriendDTO>> AcceptFriendRequest([FromRoute] int id, AcceptFriendDTO dto)
        {
            var friend = await _context.Friends.FindAsync(id);
            if (friend == null)
            {
                return NotFound();
            }

            friend.FriendRequestStatus = dto.FriendRequestStatus;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {

            }
            catch (Exception)
            {
                throw; 
            }

            return Ok(friend);
        }

        [HttpDelete("delete/{id}")]
        public async Task<IActionResult> Delete([FromRoute] int id)
        {
            var friend = await _context.Friends.FindAsync(id);
            if (friend == null)
            {
                return NotFound();
            }

            _context.Friends.Remove(friend);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
