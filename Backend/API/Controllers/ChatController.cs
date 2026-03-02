using API.DBContext;
using API.Models;
using API.DTOS;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ChatController : ControllerBase
    {
        private readonly AppDBContext _context;

        public ChatController(AppDBContext context)
        {
            _context = context;
        }
    }
}
