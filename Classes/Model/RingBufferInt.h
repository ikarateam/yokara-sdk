/**
 *
 * @author  TRANTUAN
 * @email   trantuan24bk@gmail.com
 * @website www.dnelab.com
 *
 * @version 1.0
 * @history 
 * 		27/06/2016: First created.
 */
#ifndef _RING_BUFFER_INT_H_
#define _RING_BUFFER_INT_H_

#include <stdlib.h>
#include <stdint.h>

typedef int ringbuf_t;	// Data type can be: char, int, long, float,...

class RingBufferInt
{
private:
	uint16_t buffer_size;
	
	uint16_t index_head;
    uint16_t index_tail;

    ringbuf_t* pBuffer;

    uint16_t nextIndex(uint16_t index);
    uint16_t prevIndex(uint16_t index);

public:
	
	RingBufferInt(uint16_t size);
	~RingBufferInt();

	// Add or read to/from buffer
	void push(ringbuf_t value);
	ringbuf_t pop(void);

	// Empty all elements in the buffer
	void empty(void);

	// Get number of elements stored in buffer
	uint16_t length(void);

	// Validate buffer
	uint8_t isEmpty(void);
	uint8_t isValid(void);

	// Read values
	ringbuf_t valueTail(void);
	ringbuf_t valueHead(void);
	
};

#endif /* _RING_BUFFER_H_ */
