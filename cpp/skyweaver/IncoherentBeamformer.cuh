#ifndef SKYWEAVER_INCOHERENTBEAMFORMER_CUH
#define SKYWEAVER_INCOHERENTBEAMFORMER_CUH

#include "cuda.h"
#include "psrdada_cpp/common.hpp"
#include "skyweaver/PipelineConfig.hpp"
#include "thrust/device_vector.h"

namespace skyweaver
{
namespace kernels
{

__global__ void icbf_taftp_general_k(char4 const* __restrict__ taftp_voltages,
                                     float* __restrict__ tf_powers_raw,
                                     int8_t* __restrict__ tf_powers,
                                     float const* __restrict__ output_scale,
                                     float const* __restrict__ output_offset,
                                     int nsamples);

__global__ void icbf_ftpa_general_k(char4 const* __restrict__ ftpa_voltages,
                                     float* __restrict__ tf_powers_raw,
                                     int8_t* __restrict__ tf_powers,
                                     float const* __restrict__ output_scale,
                                     float const* __restrict__ output_offset,
                                     int nsamples);                              

} // namespace kernels

/**
 * @brief      Class for incoherent beamforming.
 */
class IncoherentBeamformer
{
  public:
    // TAFTP order
    typedef thrust::device_vector<char2> VoltageVectorType;
    // TF order
    typedef thrust::device_vector<int8_t> PowerVectorType;
    // TF order
    typedef thrust::device_vector<float> RawPowerVectorType;
    // TF order
    typedef thrust::device_vector<float> ScalingVectorType;

  public:
    /**
     * @brief      Constructs an instance of the IncoherentBeamformer class
     *
     * @param      config  The pipeline config
     */
    IncoherentBeamformer(PipelineConfig const& config);
    ~IncoherentBeamformer();
    IncoherentBeamformer(IncoherentBeamformer const&) = delete;

    /**
     * @brief      Form incoherent beams
     *
     * @param      input   Input array of 8-bit voltages in TAFTP order
     * @param      output  Output array of 8-bit powers in TF order
     * @param[in]  stream  The CUDA stream to use for processing
     */
    void beamform(VoltageVectorType const& input,
                  RawPowerVectorType& output_raw,
                  PowerVectorType& output,
                  ScalingVectorType const& output_scale,
                  ScalingVectorType const& output_offset,
                  cudaStream_t stream);

  private:
    PipelineConfig const& _config;
};

} // namespace skyweaver

#endif // SKYWEAVER_INCOHERENTBEAMFORMER_CUH
