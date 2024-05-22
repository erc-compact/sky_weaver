#ifndef BUFFERED_DISPENSER_HPP
#define BUFFERED_DISPENSER_HPP

#pragma once
#include "common.hpp"
#include "skyweaver/MultifileReader.hpp"
#include "cuda.h"
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/transform.h>
#include <thrust/sequence.h>
#include <thrust/complex.h>
#include <cassert>
#include "skyweaver/PipelineConfig.hpp"
#include "cuda.h"
#include <memory>


namespace skyweaver{
    class BufferedDispenser;
}

class skyweaver::BufferedDispenser {

    public:
        typedef thrust::host_vector<char2> HostVoltageType;
        typedef thrust::device_vector<char2> DeviceVoltageType;

    private:    
        PipelineConfig const& _config;
        std::size_t _block_length_tpa; // length of nsamples * nantennas * npol  but not char2, per block of data
        std::size_t _kernel_length_tpa; // length of dedispersion kernel in samples * nantennas * npol  but not char2
        std::vector<DeviceVoltageType> _d_prev_channeled_tpa_voltages; // stores it until next iteration. This is a buffer of kernel length size for all channels in FTPA order
        std::vector<DeviceVoltageType> _d_channeled_tpa_voltages; // NCHANS=64 * TPA vectors
        cudaStream_t _stream;
    
        public:

            BufferedDispenser(PipelineConfig const& config); 
            void hoard(DeviceVoltageType const& ftpa_voltages_in, cudaStream_t stream);
            void dispense(std::size_t chan_idx, DeviceVoltageType& tpa_voltages_out);


};



#endif // BUFFERED_DISPENSER_HPP